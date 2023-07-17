# supermover.nvim

Supermover is an UI to move the current file to a different folder.

## Rationale

You are editing a file. You want to move it to another directory of the current workspace. You hit `<Leader>fm` (_file move_) and a telescope dialog pops up with a searchable list of directories. You hit enter and the file is moved.

You are editing a file. You want to move it to another directory of the current workspace. You hit `<Leader>fm` (_file move_) and a telescope dialog pops up with a searchable list of directories. You realize the directory you wanted still doesn't exist. You hit `<C-n>` (_new_) and enter the path to the new directory. You hit enter and the file is moved.

## Setup

Add the following code to your `lazy` config:

```lua
{
  "metalelf0/supermover.nvim",
  dependencies = {
    "tpope/vim-eunuch",
    "nvim-telescope/telescope.nvim"
  },
  opts = {
    bindings = {
      move_file = "<leader>fm"
    }
  },
}
```

## Usage

Hit `<Leader>fm`, choose the target directory, and hit enter.

## Todo

- [ ] allow customizing `<C-n>` telescope binding to create a new directory

## Credits

- Thanks @tpope for your great work!
- Thanks @tjdevries and all the telescope contributors!
