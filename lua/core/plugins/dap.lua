-- Set up icons.
local icons = {
    Stopped = { '', 'DiagnosticWarn', 'DapStoppedLine' },
    Breakpoint = '',
    BreakpointCondition = '',
    BreakpointRejected = { '', 'DiagnosticError' },
    LogPoint = '',
}

for name, sign in pairs(icons) do
    sign = type(sign) == 'table' and sign or { sign }
    vim.fn.sign_define('Dap' .. name, {
        -- stylua: ignore
        text = sign[1] --[[@as string]] .. ' ',
        texthl = sign[2] or 'DiagnosticInfo',
        linehl = sign[3],
        numhl = sign[3],
    })
end

return {
	{ "mxsdev/nvim-dap-vscode-js", dependencies = { "mfussenegger/nvim-dap" } },
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
      "jbyuki/one-small-step-for-vimkind",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
			{
				"microsoft/vscode-js-debug",
				-- After install, build it and rename the dist directory to out
				build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
				version = "1.*",
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				main = "dap-vscode-js",
				ft = { "javascript" },
				opts = function()
					---@diagnostic disable-next-line: missing-fields
					return {
						-- Path of node executable. Defaults to $NODE_PATH, and then "node"
						-- node_path = "node",

						-- Path to vscode-js-debug installation.
						debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),

						-- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
						-- debugger_cmd = { "js-debug-adapter" },

						-- which adapters to register in nvim-dap
						adapters = {
							"chrome",
							"pwa-node",
							"pwa-chrome",
							"pwa-msedge",
							"pwa-extensionHost",
							"node-terminal",
						},

						-- Path for file logging
						-- log_file_path = "(stdpath cache)/dap_vscode_js.log",

						-- Logging level for output to file. Set to false to disable logging.
						-- log_file_level = false,

						-- Logging level for output to console. Set to false to disable console output.
						-- log_console_level = vim.log.levels.ERROR,
					}
				end,
				config = function()
					local dap = require("dap")
					dap.configurations.javascript = {
						-- Debug single node js files
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							host = "localhost",
							port = "${port}",
							cwd = vim.fn.getcwd(),
							sourceMaps = true,
						},
					}

					--- Gets a path to a package in the Mason registry.
					--- Prefer this to `get_package`, since the package might not always be
					--- available yet and trigger errors.
					---@param pkg string
					---@param path? string
					local function get_pkg_path(pkg, path)
						pcall(require, "mason")
						local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
						path = path or ""
						local ret = root .. "/packages/" .. pkg .. "/" .. path
						return ret
					end
					dap.adapters["pwa-node"] = {
						type = "server",
						host = "localhost",
						port = "${port}",
						executable = {
							command = "node",
							args = {
								get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
								"${port}",
							},
						},
					}
				end,
			},
			{
				"Joakker/lua-json5",
				build = "./install.sh",
			},
		},
		keys = {
			{
				"<leader>tb",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>rb",
				function()
					require("dap").run_to_cursor()
				end,
			},
			{
				"<F1>",
				function()
					require("dap").continue()
				end,
			},
			{
				"<F2>",
				function()
					require("dap").step_into()
				end,
			},
			{
				"<F3>",
				function()
					require("dap").step_over()
				end,
			},
			{
				"<F4>",
				function()
					require("dap").step_out()
				end,
			},
			{
				"<F5>",
				function()
					require("dap").step_back()
				end,
			},
			{
				"<F6>",
				function()
					require("dap").restart()
				end,
			},
			{
				"<F7>",
				function()
					require("dap").terminate()
					require("dapui").close()
          end,
			},
      {
        "<leader>dl",
        function()
          require"osv".launch({port = 8086})
        end
      }

			-- -- vim.keymap.set("n", "<space>tb", dap.toggle_breakpoint)
			-- vim.keymap.set("n", "<space>rb", dap.run_to_cursor)
			-- vim.keymap.set("n", "<F1>", dap.continue)
			-- vim.keymap.set("n", "<F2>", dap.step_into)
			-- vim.keymap.set("n", "<F3>", dap.step_over)
			-- vim.keymap.set("n", "<F4>", dap.step_out)
			-- vim.keymap.set("n", "<F5>", dap.step_back)
			-- vim.keymap.set("n", "<F6>", dap.restart)
			-- vim.keymap.set("n", "<F7>", dap.terminate)
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup()

			-- Handled by nvim-dap-go
			-- dap.adapters.go = {
			--   type = "server",
			--   port = "${port}",
			--   executable = {
			--     command = "dlv",
			--     args = { "dap", "-l", "127.0.0.1:${port}" },
			--   },
			-- }

			local elixir_ls_debugger = vim.fn.exepath("elixir-ls-debugger")

			if elixir_ls_debugger ~= "" then
				dap.adapters.mix_task = {
					type = "executable",
					command = elixir_ls_debugger,
				}

				dap.configurations.elixir = {
					{
						type = "mix_task",
						name = "phoenix server",
						task = "phx.server",
						request = "launch",
						projectDir = "${workspaceFolder}",
						exitAfterTaskReturns = false,
						debugAutoInterpretAllModules = false,
					},
				}
			end
      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = "Attach to running Neovim instance",
        }
      }

      dap.adapters.nlua = function(callback, config)
        callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
      end


			require("nvim-dap-virtual-text").setup()

			-- Eval var under cursor
			vim.keymap.set("n", "<space>?", function()
				require("dapui").eval(nil, { enter = true })
			end)

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
