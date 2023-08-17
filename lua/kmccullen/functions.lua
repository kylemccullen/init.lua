function CopyWithoutSpaces()
    local start_pos = vim.fn.getpos("'<")
    local line_start = start_pos[2]

    local end_pos = vim.fn.getpos("'>")
    local line_end = end_pos[2]

    local lines = vim.fn.getline(line_start, line_end)
    -- print(dump(lines))

    local minSpaces = 1000 

    for _, line in pairs(lines) do
        if (string.len(line) > 0) then
            local lineMinSpaces = 0
            for letter in string.gmatch(line, '.') do
                if not (letter == ' ') then
                    break
                end

                lineMinSpaces = lineMinSpaces + 1
            end

            if (lineMinSpaces < minSpaces) then
                minSpaces = lineMinSpaces
            end
        end
    end
    -- print(minSpaces)

    local i = 1;
    local updated_lines = {}

    for key, line in pairs(lines) do
        if (string.len(line) == 0) then
            updated_lines[i] = ""
        else
            updated_lines[i] = string.sub(line, minSpaces + 1)
        end

        i = i + 1
    end

    print(table.concat(updated_lines, '\n'))
    vim.fn.setreg('z', table.concat(updated_lines, '\n'))
end

vim.keymap.set('v', '<C-y>', ':lua CopyWithoutSpaces()<CR>')
