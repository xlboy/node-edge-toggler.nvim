# node-edge-toggler.nvim

Toggle cursor position between the start and end of a node (replaces `%`)

https://github.com/xlboy/node-edge-toggler.nvim/assets/63690944/94624333-f768-4217-bb69-f412b735a1aa

## Installation & Usage

**Using [lazy.nvim](https://github.com/folke/lazy.nvim):**

```lua
return {
  "xlboy/node-edge-toggler.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    { "%", "<cmd>lua require('node-edge-toggler').toggle()<CR>", desc = "Node start/end toggle" },
  }
}
```

## License

[MIT](https://opensource.org/licenses/MIT)
