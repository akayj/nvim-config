local ok, tc = pcall(require, 'todo-comments')
if not ok then
    print('todo-comments is not installed')
    return
end

local keymap = vim.keymap

keymap.set("n", "]t", function() tc.jump_next() end, { desc = "Next todo comment" })
keymap.set("n", "[t", function() tc.jump_next() end, { desc = "Previous todo comment" })

keymap.set("n", "[e", function()
    tc.jump_next({ keyword = { "ERROR", "WARNING" }})
end, { desc = "Previous todo comment" })

tc.setup()

