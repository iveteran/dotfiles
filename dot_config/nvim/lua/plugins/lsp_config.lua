return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dartls = {},
        gopls = {},
        rls = {},
        rust_analyzer = {},
        clangd = {
          --cmd = {
          --  "clangd",
          --  "--background-index",
          --  "--header-insertion=iwyu",
          --  "--target=x86_64-unknown-linux-gnu",
          --  "--query-driver=/usr/bin/g++"  -- Use your C++ compiler path
          --},
          --init_options = {
          --  compilationDatabasePath = "build"  -- If you have a compile_commands.json in a build dir
          --}
        },
        --ccls = {},
      },
    },
  },
}
