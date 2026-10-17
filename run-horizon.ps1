# Horizon 启动脚本
# 用法:
#   .\run-horizon.ps1                 # 抓取最近 24 小时并生成中英双语日报
#   .\run-horizon.ps1 -Hours 48       # 抓取最近 48 小时
#   .\run-horizon.ps1 -LogLevel INFO  # 显示详细日志

param(
    [int]$Hours = 24,
    [ValidateSet('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL')]
    [string]$LogLevel = 'WARNING'
)

$ErrorActionPreference = 'Stop'

# 修复某些环境把 NO_PROXY 写成 [::1] 导致 httpx 报 Invalid port 的问题
$noProxy = $env:NO_PROXY
if ($noProxy -and $noProxy -match '\[') {
    $env:NO_PROXY = ($noProxy -replace '\[|\]', '')
    $env:no_proxy = $env:NO_PROXY
}

Set-Location -LiteralPath $PSScriptRoot

uv run horizon --hours $Hours -l $LogLevel
