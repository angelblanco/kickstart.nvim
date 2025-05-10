local openRouterModel = 'qwen/qwen-2.5-coder-32b-instruct:free'

if os.getenv 'OPENROUTER_DEFAULT_MODEL' then
  openRouterModel = os.getenv 'OPENROUTER_DEFAULT_MODEL'
end

return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false, -- Never set this value to "*"! Never!
    opts = {
      provider = 'openrouter',
      vendors = {
        openrouter = {
          __inherited_from = 'openai',
          endpoint = 'https://openrouter.ai/api/v1',
          api_key_name = 'OPENROUTER_API_KEY',
          model = openRouterModel,
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    },
    keys = {
      {
        '<leader>tac',
        '<cmd>AvanteChat<cr>',
        desc = '[T]oggle [A]vante [C]hat',
      },
      {
        '<leader>tan',
        '<cmd>AvanteChatNew<cr>',
        desc = '[T]oggle [A]vante [N]ew chat',
      },
    },
  },
}
