-- Bantas Programming Language Interpreter (Browser-Friendly Version)
-- Creator: Jon Velasco
-- Date: 2025-10-08
-- Version: 1.4.7 Beta (Web Version - Full Featured)

-- --- Global Debug State ---
DEBUG_MODE = false

-- --- Core Interpreter State ---
local stacks = {}
local active_position = nil -- No default active stack
local lines = {}
local pc = 1
local jump_map = {}
local VIRTUAL_STACK_POS = 0 -- Renamed for clarity and to match the @0 reference
local loop_counter_stack = {}

-- --- Helper and Debugging Functions ---

function print_error(line_number, message)
    js_error("Error on line " .. line_number .. ": " .. message)
    if lines and lines[line_number] then
        js_error("  " .. lines[line_number]:match("^%s*.-%s*$") .. "\n  ^")
    end
end


function parse_line(line)
    local in_quote = false
    local comment_start = 0
    for i = 1, #line do
        local char = line:sub(i, i)
        if char == '"' then
            in_quote = not in_quote
        elseif char == "'" and not in_quote then
            comment_start = i
            break
        end
    end

    if comment_start > 0 then
        line = line:sub(1, comment_start - 1)
    end

    if #line == 0 then return "", nil end

    local comma_pos = line:find(",")
    if not comma_pos then
        local trimmed_line = line:match("^%s*(.-)%s*$")
        if trimmed_line == "" then
            return "", nil
        end
        local valid_no_comma_cmds = { ["`"]=true, ["!"]=true, [";"]=true, ["_"]=true, ["@"]=true, ["+"]=true, ["-"]=true, ["]"]=true, ["["]=true }
        if valid_no_comma_cmds[trimmed_line] then
            return trimmed_line, nil
        else
            return "__ERROR_NO_COMMA__", line
        end
    end
    local cmd = line:sub(1, comma_pos - 1)
    local arg = line:sub(comma_pos + 1)
    cmd = cmd:match("^%s*(.-)%s*$")
    return cmd, arg
end

-- Find innermost enclosing loop start line for current pc (returns start_line or nil)
function find_current_loop(pc, jump_map)
    local best_start = -1
    for start_line, info in pairs(jump_map) do
        if type(info) == "table" and info.type == "loop_start"
           and start_line <= pc and info.end_line >= pc then
            if start_line > best_start then
                best_start = start_line
            end
        end
    end
    if best_start ~= -1 then
        return best_start
    end
    return nil
end

-- Helper: get the loop counter index for the current innermost loop (if any)
function current_loop_counter_index()
    local start_line = find_current_loop(pc, jump_map)
    if not start_line then return nil end
    local info = jump_map[start_line]
    if info and info.counter_index then
        return info.counter_index
    end
    return nil
end

-- Updated function to correctly handle commas in numbers and resolve '@'
function get_value(arg)
    if not arg then return nil end
    local value

    -- Trim the raw argument to handle cases like `, "hello" `
    local trimmed_arg = arg:match("^%s*(.-)%s*$")

    -- 1. Check for QUOTED string literals first.
    if #trimmed_arg >= 2 and trimmed_arg:sub(1, 1) == '"' and trimmed_arg:sub(-1) == '"' then
        -- For quoted strings, the value is the exact content inside the quotes.
        value = trimmed_arg:sub(2, -2)
    else
        -- 2. If not a quoted string, it's a reference, number, or UNQUOTED string.
        -- For these, we use the trimmed argument for all processing.
        if trimmed_arg:sub(1, 2) == "@@" then
            local index_stack_str = trimmed_arg:sub(3)
            local index_stack_num = tonumber(index_stack_str)
            if index_stack_num then
                local target_stack_num = stacks[index_stack_num]
                if target_stack_num and type(target_stack_num) == "number" then
                    value = stacks[target_stack_num]
                end
            end
        elseif trimmed_arg == "@0" or (trimmed_arg == "@" and active_position == VIRTUAL_STACK_POS) then
            local ci = current_loop_counter_index()
            if ci then
                value = loop_counter_stack[ci]
            else
                value = nil
            end
        elseif trimmed_arg:sub(1, 1) == "@" and #trimmed_arg > 1 then
            local pos = tonumber(trimmed_arg:sub(2))
            value = pos and stacks[pos] or nil
        elseif trimmed_arg == "@" then
            value = stacks[active_position]
        else
            -- It's a literal. Try to convert to a number.
            local clean_arg = trimmed_arg:gsub(",", "")
            local num = tonumber(clean_arg)
            if num then
                value = num
            else
                -- If it's not a number, it's an UNQUOTED string literal.
                -- Revert to using the raw argument to preserve all whitespace.
                value = arg
            end
        end
    end

    return value
end

function get_active_stack_value()
    if active_position == nil then return nil end
    if active_position == VIRTUAL_STACK_POS then
        -- get the loop counter for the current innermost loop
        local ci = current_loop_counter_index()
        if ci then
            return loop_counter_stack[ci]
        else
            return nil
        end
    else
        return stacks[active_position]
    end
end

function set_active_stack_value(value)
    if active_position == nil then return end
    if active_position == VIRTUAL_STACK_POS then
        local ci = current_loop_counter_index()
        if ci then
            loop_counter_stack[ci] = value
        else
            -- no loop context: ignore or error would have been raised earlier
        end
    else
        stacks[active_position] = value
    end
end

-- --- Conditions ---
function evaluate_if_condition(active_value, arg_string)
    if not arg_string or arg_string == "" then return false end
    local operator = arg_string:sub(1, 1)
    local value_str
    if operator == "<" or operator == ">" or operator == "=" then
        value_str = arg_string:sub(2):match("^%s*(.-)%s*$")
    else
        operator = "="
        value_str = arg_string:match("^%s*(.-)%s*$")
    end
    local arg_value = get_value(value_str)
    if (operator == "<" or operator == ">") and (type(active_value) ~= "number" or type(arg_value) ~= "number") then
        return false
    end
    if operator == "=" then
        return active_value == arg_value
    elseif operator == "<" then
        return active_value < arg_value
    elseif operator == ">" then
        return active_value > arg_value
    end
    return false
end

-- --- Formatting Engine ---
-- Updated function to correctly implement Capital Case ('c' or 'C')
function format_string(value, code)
    local prepend_spaces_str, case_cmd, append_spaces_str = code:match("^(%d*)([uUlLcC])(%d*)$")
    if not case_cmd then
        return false, "Invalid string format code: '" .. code .. "'"
    end

    local prepend_spaces = tonumber(prepend_spaces_str) or 0
    local append_spaces = tonumber(append_spaces_str) or 0
    case_cmd = case_cmd:lower()

    local formatted_value = value
    if case_cmd == 'u' then
        formatted_value = formatted_value:upper()
    elseif case_cmd == 'l' then
        formatted_value = formatted_value:lower()
    elseif case_cmd == 'c' then
        -- This pattern finds and capitalizes the first letter of each word.
        -- It first converts the string to lowercase to handle any existing capitals.
        formatted_value = formatted_value:lower():gsub("(%a)(%w*)", function(first, rest)
            return first:upper() .. rest
        end)
    end

    local result = string.rep(" ", prepend_spaces) .. formatted_value .. string.rep(" ", append_spaces)
    return true, result
end

function insert_commas(s)
    -- Handle negative numbers
    local is_negative = false
    if s:sub(1, 1) == "-" then
        is_negative = true
        s = s:sub(2)
    end
    
    local reversed = s:reverse()
    local with_commas = reversed:gsub("(%d%d%d)", "%1,")
    local final = with_commas:reverse()
    
    -- Remove leading comma if present
    if final:sub(1, 1) == "," then
        final = final:sub(2)
    end
    
    -- Restore negative sign
    if is_negative then
        final = "-" .. final
    end
    
    return final
end

function format_by_rules(number, rules)
    -- Handle rounding first
    local rounded_number
    if rules.decimals > 0 then
        local factor = 10^rules.decimals
        rounded_number = math.floor(math.abs(number) * factor + 0.5) / factor
        if number < 0 then
            rounded_number = -rounded_number
        end
    else
        rounded_number = math.floor(number + 0.5 * (number >= 0 and 1 or -1))
    end
    
    -- Split into integer and fractional parts
    local is_negative = rounded_number < 0
    local integer_part_num = math.floor(math.abs(rounded_number))
    
    local integer_str = tostring(integer_part_num)
    
    -- Apply padding to the integer part (digits only)
    local integer_padding_needed = rules.min_width - #integer_str
    if integer_padding_needed > 0 then
        local padding = string.rep(rules.pad_char, integer_padding_needed)
        integer_str = padding .. integer_str
    end

    -- Add commas if requested
    if rules.use_commas then
        integer_str = insert_commas(integer_str)
    end
    
    -- Handle fractional part
    local fraction_str = ""
    if rules.decimals > 0 then
        local fraction_part = math.abs(rounded_number) - math.floor(math.abs(rounded_number))
        fraction_str = string.format("%." .. rules.decimals .. "f", fraction_part)
        -- Extract only the decimal part (remove "0." prefix)
        fraction_str = fraction_str:match("%.(%d+)$") or ""
        -- Pad with zeros if needed
        if #fraction_str < rules.decimals then
            fraction_str = fraction_str .. string.rep("0", rules.decimals - #fraction_str)
        end
    end
    
    -- Add sign
    if is_negative then
        integer_str = "-" .. integer_str
    end
    
    -- Build final string
    local final_str = integer_str
    if rules.decimals > 0 then
        final_str = final_str .. "." .. (fraction_str or string.rep("0", rules.decimals))
    end

    return true, final_str
end

-- --- Preprocess code ---
function preprocess_code(code_lines)
    local loop_stack = {}
    local if_stack = {}
    jump_map = {}
    for i, line in ipairs(code_lines) do
        local cmd, arg = parse_line(line)

        if cmd == "[" then
            table.insert(loop_stack, {line_num = i, arg = arg, has_explicit_step = false})
        elseif cmd == "+" or cmd == "-" then
            if #loop_stack > 0 then
                loop_stack[#loop_stack].has_explicit_step = true
            end
        elseif cmd == "]" then
            if #loop_stack > 0 then
                local start_info = table.remove(loop_stack)
                jump_map[start_info.line_num] = { type = "loop_start", end_line = i, start_arg = start_info.arg, termination_arg = arg, has_explicit_step = start_info.has_explicit_step, saved_active_pos = nil, counter_index = nil}
                jump_map[i] = { type = "loop_end", start_line = start_info.line_num, termination_arg = arg }
            end
        elseif cmd == "#" then
            table.insert(if_stack, i)
        elseif cmd == "!" then
            if #if_stack > 0 then
                local if_start_line = table.remove(if_stack)
                jump_map[if_start_line] = i
                table.insert(if_stack, i)
            end
        elseif cmd == ";" then
            if #if_stack > 0 then
                local if_or_else_start_line = table.remove(if_stack)
                jump_map[if_or_else_start_line] = i
            end
        end
    end
end

-- --- Main Execution ---
function run_interpreter(source_code)
    lines, stacks, pc, active_position, jump_map = {}, {}, 1, nil, {}
    loop_counter_stack = {}

    for line in (source_code..'\n'):gmatch("(.-)\r?\n") do
        table.insert(lines, line)
    end
    preprocess_code(lines)

    while pc <= #lines do
        local line = lines[pc]
        if not line then break end
        cmd, arg = parse_line(line)

        if cmd == "__ERROR_NO_COMMA__" then
            print_error(pc, "Missing comma delimiter. All commands (except for ``, !, ;, +, - and _) must be followed by a comma.")
            return
        end
        
        -- Special check for commands that don't need an active stack
        local no_active_stack_cmds = { [""]=true, ["@"]=true, ["`"]=true, [";"]=true, ["!"]=true, ["-"]=true, ["+"]=true, ["_"]=true, ["["]=true, ["]"]=true, ["?"]=true, ["??"]=true }
        local needs_active_stack = true
        if no_active_stack_cmds[cmd] then
            needs_active_stack = false
        end
        
        -- Handle shorthand for + and -
        if (cmd == "+" or cmd == "-") and arg == nil and active_position == VIRTUAL_STACK_POS then
            arg = "1"
        end

        if needs_active_stack and (active_position == nil) then
            print_error(pc, "No active stack set. Use '@,1' or a similar command to select a stack first.")
            return
        end

        if cmd == "" then
            -- This is an empty line, do nothing
        elseif cmd == "@" then
            if arg == "" then
                -- @, (no argument) is still for loop-local counter manipulation
                local current_loop = find_current_loop(pc, jump_map)
                if not current_loop then
                    print_error(pc, "Command '@,' with no argument can only be used inside a loop to make the loop counter active.")
                    return
                end
                active_position = VIRTUAL_STACK_POS
            else
                local resolved_arg = get_value(arg)
                if type(resolved_arg) == "number" then
                    if resolved_arg == VIRTUAL_STACK_POS then
                        -- @,0 selects loop counter for the current loop
                        local current_loop = find_current_loop(pc, jump_map)
                        if not current_loop then
                            print_error(pc, "Command '@,0' can only be used inside a loop.")
                            return
                        end
                        active_position = VIRTUAL_STACK_POS
                    else
                        active_position = resolved_arg
                    end
                else
                    print_error(pc, "Invalid argument for @. Must be a number or a reference that resolves to a number, or used as '@,' or '@,0'.")
                    return
                end
            end
        elseif cmd == "<" then
            local value_to_store = get_value(arg)
            if value_to_store == nil then
                print_error(pc, "Command '<' requires a valid value to store.")
                return
            end
            if active_position == VIRTUAL_STACK_POS then
                -- set value for the current loop counter slot
                local ci = current_loop_counter_index()
                if ci then
                    loop_counter_stack[ci] = value_to_store
                else
                    print_error(pc, "No loop context for virtual stack '<'.") return
                end
            else
                stacks[active_position] = value_to_store
            end
        elseif cmd == ">" then
            local prompt_text = get_value(arg)
            local input = bantas_prompt(tostring(prompt_text or ""), coroutine.running())
            
            if active_position == VIRTUAL_STACK_POS then
                local ci = current_loop_counter_index()
                if ci then
                    loop_counter_stack[ci] = tonumber(input) or input or ""
                else
                    print_error(pc, "No loop context for virtual stack '>' on input.") return
                end
            else
                stacks[active_position] = tonumber(input) or input or ""
            end
        elseif cmd == "?" then
            local value = get_value(arg)
            if value == nil or (type(value) == "string" and value == "") then
                js_print()
            else
                js_print(value)
            end
        elseif cmd == "??" then
            local value = get_value(arg)
            if value ~= nil and value ~= "" then
                js_print_inline(tostring(value))
            end
        elseif cmd == "+" then
            local val2 = get_value(arg)
            if type(val2) ~= "number" then print_error(pc, "Argument for + must be a number.") return end
            
            local val1 = get_active_stack_value() or 0
            if type(val1) ~= "number" then print_error(pc, "Active stack value is not a number.") return end
            set_active_stack_value(val1 + val2)

        elseif cmd == "-" then
            local val2 = get_value(arg)
            if type(val2) ~= "number" then print_error(pc, "Argument for - must be a number.") return end
            
            local val1 = get_active_stack_value() or 0
            if type(val1) ~= "number" then print_error(pc, "Active stack value is not a number.") return end
            set_active_stack_value(val1 - val2)

        elseif cmd == "*" then
            local val2 = get_value(arg)
            if type(val2) ~= "number" then print_error(pc, "Argument for * must be a number.") return end
            
            local val1 = get_active_stack_value() or 0
            if type(val1) ~= "number" then print_error(pc, "Active stack value is not a number.") return end
            set_active_stack_value(val1 * val2)
            
        elseif cmd == "///" then
            -- MODULO LOGIC
            local val2 = get_value(arg)
            if type(val2) ~= "number" then print_error(pc, "Argument for /// must be a number.") return end
            if val2 == 0 then print_error(pc, "Modulo by zero.") return end
            local val1 = get_active_stack_value() or 0
            if type(val1) ~= "number" then print_error(pc, "Active stack value is not a number.") return end
            set_active_stack_value(val1 % val2)

        elseif cmd == "//" then
            -- INTEGER DIVISION LOGIC
            local val2 = get_value(arg)
            if type(val2) ~= "number" then print_error(pc, "Argument for // must be a number.") return end
            if val2 == 0 then print_error(pc, "Division by zero.") return end
            local val1 = get_active_stack_value() or 0
            if type(val1) ~= "number" then print_error(pc, "Active stack value is not a number.") return end
            set_active_stack_value(math.floor(val1 / val2))

        elseif cmd == "/" then
            local val2 = get_value(arg)
            if type(val2) ~= "number" then print_error(pc, "Argument for / must is a number.") return end
            if val2 == 0 then print_error(pc, "Division by zero.") return end
            
            local val1 = get_active_stack_value() or 0
            if type(val1) ~= "number" then print_error(pc, "Active stack value is not a number.") return end
            set_active_stack_value(val1 / val2)
        elseif cmd == "&" then
            local val1 = tostring(get_active_stack_value() or "")
            local val2 = tostring(get_value(arg) or "")
            set_active_stack_value(val1 .. val2)

        elseif cmd == "[" then
            local loop_info = jump_map[pc]
            if loop_info and loop_info.type == "loop_start" then
                if not loop_info.initialized then
                    -- Evaluate start value in current context and push to loop_counter_stack
                    local start_value = get_value(loop_info.start_arg)
                    table.insert(loop_counter_stack, start_value)
                    -- record this counter's index for this loop start
                    loop_info.counter_index = #loop_counter_stack

                    jump_map[pc].initialized = true
                    jump_map[pc].saved_active_pos = active_position -- Save the current active stack
                    
                    -- Always calculate direction when loop is initialized
                    local term_arg_str = tostring(loop_info.termination_arg or "")
                    local operator = term_arg_str:match("^[=<>%%?]")
                    local value_str
                    if operator then
                        value_str = term_arg_str:sub(2)
                    else
                        value_str = term_arg_str
                    end
                    -- evaluate termination_value in the saved active context
                    local prior_active = active_position
                    active_position = loop_info.saved_active_pos
                    local termination_value = get_value(value_str)
                    active_position = prior_active

                    local current_value = loop_counter_stack[loop_info.counter_index]
                    if type(current_value) == "number" and type(termination_value) == "number" then
                        if current_value < termination_value then
                            jump_map[pc].direction = "inc"
                        elseif current_value > termination_value then
                            jump_map[pc].direction = "dec"
                        else
                            jump_map[pc].direction = "equals"
                        end
                    else
                        jump_map[pc].direction = nil -- for non-numeric loops
                    end

                    active_position = VIRTUAL_STACK_POS -- Set the active stack to the virtual loop stack
                end
            else
                print_error(pc, "Unmatched [ or invalid loop structure.") return
            end
        elseif cmd == "]" then
            local loop_info = jump_map[pc]
            if loop_info and loop_info.type == "loop_end" then
                local start_line = loop_info.start_line
                local start_loop_info = jump_map[start_line]

                -- Parse operator and value string from termination argument
                local term_arg_str = tostring(loop_info.termination_arg or "")
                local operator = term_arg_str:match("^[=<>%%?]")
                local value_str
                if operator then
                    value_str = term_arg_str:sub(2)
                else
                    value_str = term_arg_str
                end

                -- Evaluate termination value in the saved active stack context
                local inside_loop_active_pos = active_position
                active_position = start_loop_info.saved_active_pos
                local termination_value = get_value(value_str)
                -- Restore context
                active_position = inside_loop_active_pos

                local ci = start_loop_info.counter_index
                if not ci then
                    print_error(pc, "Internal loop error: counter index missing.") return
                end

                local current_value = loop_counter_stack[ci]
                local continue_loop = false
                local direction = start_loop_info and start_loop_info.direction

                if operator then
                    -- New logic for while-style loops (with relational operators)
                    if not start_loop_info.has_explicit_step then
                        if type(current_value) == "number" then
                            if direction == "inc" then
                                loop_counter_stack[ci] = current_value + 1
                            elseif direction == "dec" then
                                loop_counter_stack[ci] = current_value - 1
                            end
                            current_value = loop_counter_stack[ci]
                        end
                    end
                    
                    if type(current_value) ~= "number" or type(termination_value) ~= "number" then
                        if operator == "=" then continue_loop = (current_value == termination_value)
                        else print_error(pc, "Relational operators < and > require numeric values.") return end
                    else
                        if operator == "=" then continue_loop = (current_value == termination_value)
                        elseif operator == "<" then continue_loop = (current_value < termination_value)
                        elseif operator == ">" then continue_loop = (current_value > termination_value) end
                    end
                else
                    -- Original logic for for-style loops (for backward compatibility)
                    if start_loop_info.has_explicit_step then
                        if type(current_value) == "number" and type(termination_value) == "number" then
                            if direction == "inc" then continue_loop = current_value <= termination_value
                            elseif direction == "dec" then continue_loop = current_value >= termination_value
                            else continue_loop = current_value == termination_value end
                        else
                            continue_loop = current_value ~= termination_value
                        end
                    else
                        if type(current_value) == "number" and type(termination_value) == "number" then
                            if direction == "inc" then
                                loop_counter_stack[ci] = current_value + 1
                                current_value = loop_counter_stack[ci]
                                continue_loop = current_value <= termination_value
                            elseif direction == "dec" then
                                loop_counter_stack[ci] = current_value - 1
                                current_value = loop_counter_stack[ci]
                                continue_loop = current_value >= termination_value
                            else
                                continue_loop = false
                            end
                        else
                            continue_loop = false
                        end
                    end
                end
                
                if continue_loop then
                    pc = start_line
                    goto next_instruction
                else
                    -- remove this loop's counter slot (should be the top-of-stack if loops were nested correctly)
                    table.remove(loop_counter_stack, ci)
                    jump_map[start_line].initialized = false
                    jump_map[start_line].counter_index = nil
                    active_position = start_loop_info.saved_active_pos -- Restore the saved active stack
                end
            else
                print_error(pc, "Unmatched ] or invalid loop structure.") return
            end
        elseif cmd == "_" then
            local value_to_measure = get_value(arg)
            if value_to_measure == nil then
                print_error(pc, "Argument for '_' resolves to nil. This command requires a valid value.")
                return
            end
            local str = tostring(value_to_measure)
            set_active_stack_value(#str)
        elseif cmd == ")" then
            local str = get_active_stack_value()
            if type(str) ~= "string" then
                print_error(pc, "Active stack value for ')' must be a string.") return
            end
            local index_val = get_value(arg)
            if type(index_val) ~= "number" then
                print_error(pc, "Invalid argument for ').' Expecting a number for length.") return
            end
            local index = tonumber(index_val)
            if index then
                set_active_stack_value(str:sub(-index))
            else
                print_error(pc, "Invalid argument for ). Expecting a number for index.") return
            end
        elseif cmd == "(" then
            local str = get_active_stack_value()
            if type(str) ~= "string" then
                print_error(pc, "Active stack value for '(' must be a string.") return
            end
            local len_val = get_value(arg)
            if type(len_val) ~= "number" then
                print_error(pc, "Invalid argument for '('. Expecting a number for length.") return
            end
            local len = tonumber(len_val)
            if len then
                set_active_stack_value(str:sub(1, len))
            else
                print_error(pc, "Invalid argument for (. Expecting a number for length.") return
            end
        elseif cmd == "{" then
            local degrees = get_value(arg)
            if type(degrees) ~= "number" then
                print_error(pc, "Invalid argument for sine. Expecting a number.") return
            end
            set_active_stack_value(math.sin(degrees * (math.pi / 180)))
        elseif cmd == "}" then
            local degrees = get_value(arg)
            if type(degrees) ~= "number" then
                print_error(pc, "Invalid argument for cosine. Expecting a number.") return
            end
            set_active_stack_value(math.cos(degrees * (math.pi / 180)))
        elseif cmd == "\\" then
            local degrees = get_value(arg)
            if type(degrees) ~= "number" then
                print_error(pc, "Invalid argument for tangent. Expecting a number.")
                return
            end
            set_active_stack_value(math.tan(degrees * (math.pi / 180)))
        elseif cmd == "^" then
            local base = get_active_stack_value() or 0
            local exponent = get_value(arg)
            if type(base) ~= "number" or type(exponent) ~= "number" then
                print_error(pc, "Invalid arguments for exponentiation. Both must be numbers.")
                return
            end
            set_active_stack_value(base ^ exponent)
        elseif cmd == "$" then
            local max_val = get_value(arg)
            if type(max_val) ~= "number" or max_val < 1 then
                print_error(pc, "Argument for $ must be a number greater than or equal to 1.")
                return
            end
            set_active_stack_value(math.random(max_val))
        elseif cmd == "#" then
            local active_value = get_active_stack_value()
            if not evaluate_if_condition(active_value, arg) then
                if jump_map[pc] then
                    pc = jump_map[pc]
                else
                    print_error(pc, "Unmatched #.") return
                end
            end
        elseif cmd == "!" then
            if jump_map[pc] then
                pc = jump_map[pc]
            else
                print_error(pc, "Unmatched ! without matching #.") return
            end
        elseif cmd == ";" then
        elseif cmd == "~" then
            print_error(pc, "Dump to file '~' not supported in browser.")
        elseif cmd == "." then
            local char = get_value(arg)
            if type(char) ~= "string" or #char ~= 1 then
                print_error(pc, "Argument for . must be a single character string.")
                return
            end
            set_active_stack_value(string.byte(char))
        elseif cmd == ":" then
            local code = get_value(arg)
            if type(code) ~= "number" then
                print_error(pc, "Argument for : must be a number.")
                return
            end
            set_active_stack_value(string.char(code))
        elseif cmd == "`" then
            print_error(pc, "Shell command '`' not supported in browser.")
        elseif cmd == "><" then -- NEW COMMAND
            local value_to_trim = get_value(arg)
            if type(value_to_trim) == "string" then
                local trimmed_value = value_to_trim:match("^%s*(.-)%s*$")
                set_active_stack_value(trimmed_value)
            else
                -- If not a string (e.g., a number), just store the original value back
                set_active_stack_value(value_to_trim)
            end
        elseif cmd == "|" then
            print_error(pc, "Load from file '|' not supported in browser.")
        elseif cmd == "%" then
            local code = arg:match("^%s*(.-)%s*$")
            if #code > 1 and code:sub(1,1) == '"' and code:sub(-1) == '"' then
                code = code:sub(2, -2)
            end
            if code == "" or not code then
                print_error(pc, "Argument for % command is missing.")
                return
            end

            local value_to_format = get_active_stack_value()
            local success, result

            if type(value_to_format) == "number" then
                local rules = {}
                local code_upper = code:upper()
                local m_decimal_str = code_upper:match("^M(%d*)$")
                local f_decimal_str = code_upper:match("^F(%d*)$")

                -- Handle flexible M (Monetary) shorthand
                if m_decimal_str ~= nil then
                    rules = { use_commas = true, pad_char = ' ' }
                    if m_decimal_str == "" then
                        rules.decimals = 0
                    else
                        rules.decimals = tonumber(m_decimal_str)
                    end
                    rules.min_width = 0

                -- Handle I (Integer) shorthand
                elseif code_upper == "I" then
                    rules = { use_commas = false, decimals = 0, min_width = 0, pad_char = ' ' }

                -- Handle flexible F (Float) shorthand
                elseif f_decimal_str ~= nil then
                    rules = { use_commas = false, pad_char = ' ' }
                    if f_decimal_str == "" then
                        rules.decimals = 0
                    else
                        rules.decimals = tonumber(f_decimal_str)
                    end
                    rules.min_width = 0

                elseif code:find("0") or code:find("#") or code:find(",") then
                    -- Parse as a template
                    rules.use_commas = code:find(",") and true or false
                    
                    -- Count decimal places
                    local dot_pos = code:find("%.")
                    if dot_pos then
                        local after_dot = code:sub(dot_pos + 1)
                        -- Only count digit placeholders after decimal point
                        rules.decimals = after_dot:gsub("[^0#]", ""):len()
                    else
                        rules.decimals = 0
                    end
                    
                    -- Calculate minimum width for INTEGER PART ONLY
                    local integer_part_template
                    if dot_pos then
                        integer_part_template = code:sub(1, dot_pos - 1)
                    else
                        integer_part_template = code
                    end
                    -- Remove commas from integer part template for width calculation
                    integer_part_template = integer_part_template:gsub(",", "")
                    rules.min_width = integer_part_template:len()
                    
                    -- Determine padding character based on the integer part of the template
                    if integer_part_template:find("0") then
                        rules.pad_char = '0'
                    else
                        rules.pad_char = ' '
                    end
                else
                    print_error(pc, "Invalid number format code: '" .. code .. "'")
                    return
                end
                
                success, result = format_by_rules(value_to_format, rules)

            elseif type(value_to_format) == "string" then
                success, result = format_string(value_to_format, code)
            else
                print_error(pc, "% command requires a number or string in the active stack.")
                return
            end

            if not success then
                print_error(pc, result) -- result contains the error message
                return
            end

            set_active_stack_value(result)
        else
            print_error(pc, "Unknown command '" .. cmd .. "'.") return
        end

        pc = pc + 1
        ::next_instruction::
    end
end
