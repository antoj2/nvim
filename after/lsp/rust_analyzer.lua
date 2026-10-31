local cwd = vim.uv.cwd() or ''

local cargo_settings = {}
if cwd:find('kernel', 1, true) then
  cargo_settings = { target = 'x86_64-unknown-none' }
end

return {
  settings = {
    ['rust-analyzer'] = {
      cargo = cargo_settings,
      check = {
        enable = true,
        command = 'clippy',
        features = 'all',
      },
    },
  },
}
