if true then
    return {}
end

return {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "saghen/blink.cmp" },
    config = function()
        require("minuet").setup({
            provider = "openai_fim_compatible",
            n_completions = 3,
            context_window = 512,
            provider_options = {
                openai_fim_compatible = {
                    api_key = "TERM",
                    name = "Ollama",
                    end_point = "http://localhost:11434/v1/completions",
                    model = "qwen2.5-coder:7b",
                    stream = true,
                    optional = {
                        max_tokens = 56,
                        top_p = 0.9,
                    },
                },
            },
            presets = {
                local_fast = {
                    provider = "openai_fim_compatible",
                    n_completions = 5,
                    context_window = 512,
                    throttle = 400,
                    debounce = 100,
                    provider_options = {
                        openai_fim_compatible = {
                            api_key = "TERM",
                            name = "Ollama",
                            end_point = "http://localhost:11434/v1/completions",
                            model = "qwen2.5-coder:7b",
                            optional = { max_tokens = 56, top_p = 0.9 },
                        },
                    },
                },
                gemini_strong = {
                    provider = "gemini",
                    n_completions = 5,
                    context_window = 8000, -- can afford much more context via API
                    throttle = 1500, -- higher throttle = fewer paid requests
                    debounce = 600,
                    provider_options = {
                        gemini = {
                            model = "gemini-2.0-flash", -- cheap, fast; use gemini-2.5-pro if you want max quality
                            -- GEMINI_API_KEY should be an environment variable, not hard-coded here!
                            api_key = "GEMINI_API_KEY", -- env var name, not the key itself
                            optional = {
                                generationConfig = {
                                    maxOutputTokens = 256,
                                    thinkingConfig = { thinkingBudget = 0 }, -- disable thinking for latency
                                },
                            },
                        },
                    },
                },
            },
        })
    end,
}
