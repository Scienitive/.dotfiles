vim.g.mapleader = " "

local keymap = vim.keymap

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- visual mode carrying code block
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- seperate copy-paste buffers
keymap.set({'n', 'v'}, '<leader>y', '"+y')
keymap.set({'n', 'v'}, '<leader>Y', '"+Y')

keymap.set({'n', 'v'}, '<leader>d', '"+d')
keymap.set({'n', 'v'}, '<leader>D', '"+D')

keymap.set('n', '<leader>p', '"+p')
keymap.set('n', '<leader>P', '"+P')

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>") -- find files inside current git files
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
keymap.set("n", "<leader>fr", "<cmd>Telescope resume<cr>")

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<CR>") -- toggle file explorer
keymap.set("n", "<leader>c", ":NvimTreeCollapse<CR>") -- toggle file explorer

-- disable arrow keys
keymap.set({"n", "v", "i"}, "<Up>", "<Nop>")
keymap.set({"n", "v", "i"}, "<Left>", "<Nop>")
keymap.set("n", "<leader>-", "<C-x>") -- decrement
keymap.set({"n", "v", "i"}, "<Right>", "<Nop>")
keymap.set({"n", "v", "i"}, "<Down>", "<Nop>")
