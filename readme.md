# Chezmoi 简明使用手册

您的 `chezmoi` 源目录位于：`~/.local/share/chezmoi`

## 1. 核心概念
*   **源目录 (Source State)**：位于 `~/.local/share/chezmoi`，这是被 Git 管理的代码仓库。
*   **目标状态 (Target State)**：您的家目录 `~`。
*   **命名规则**：
    *   `dot_` 前缀：对应目标位置的隐藏文件（点文件）。例如 `dot_zshrc` -> `~/.zshrc`。
    *   `readonly_` 前缀：应用后在目标位置为只读。
    *   `empty_` 前缀：即使源文件为空，也会在目标位置创建该文件。

## 2. 常用命令速查

| 操作 | 命令 | 说明 |
| :--- | :--- | :--- |
| **应用更新** | `chezmoi apply` | 将源目录的配置同步到家目录（最常用） |
| **添加文件** | `chezmoi add <文件>` | 将现有的配置文件纳入 chezmoi 管理 |
| **编辑源文件** | `chezmoi edit <文件>` | 编辑源目录中的文件，保存后可自动应用 |
| **查看差异** | `chezmoi diff` | 查看源目录与当前家目录配置的区别 |
| **进入源目录** | `chezmoi cd` | 直接进入 `~/.local/share/chezmoi` 所在的 Shell |
| **状态查询** | `chezmoi status` | 查看哪些文件已被修改且尚未应用 |

## 3. 标准工作流

**场景 A：修改现有配置**
1.  执行 `chezmoi edit ~/.zshrc`。
2.  编辑并保存（这会直接修改源目录里的 `dot_zshrc`）。
3.  执行 `chezmoi apply` 将更改同步到系统。

**场景 B：添加新配置（如新装了软件）**
1.  执行 `chezmoi add ~/.config/new_tool/config.toml`。
2.  进入源目录：`chezmoi cd`。
3.  提交更改：`git add . && git commit -m "Add new_tool config" && git push`。

**场景 C：在另一台机器上同步**
1.  安装 `chezmoi`。
2.  初始化：`chezmoi init <您的仓库URL>`。
3.  查看差异：`chezmoi diff`。
4.  应用：`chezmoi apply`。

## 4. 您当前的配置结构
*   **Shell**: `zsh` (`.zshrc`, `.p10k.zsh`)。
*   **编辑器**: `nvim` (完整的插件配置)。
*   **终端与环境**: `ghostty`, `zellij`, `niri`, `yazi`。
*   **Git**: `.gitconfig` 已通过 `dot_gitconfig` 管理。

## 5. 进阶：加密与密钥管理

### 加密文件 (使用 rage)
对于 SSH 密钥等敏感文件，建议使用 `rage` 进行加密：
1.  **配置**：在 `~/.config/chezmoi/chezmoi.toml` 中指定加密方式：
    ```toml
    encryption = "age"
    [age]
        identity = "~/.config/chezmoi/key.txt"
        recipient = "age1..." # 您的公钥
    ```
2.  **添加加密文件**：使用 `--encrypt` 参数：
    `chezmoi add --encrypt ~/.ssh/id_rsa`
3.  **注意**：在源目录中，该文件会以 `.age` 后缀存储。

### 密钥管理 (使用 Bitwarden)
避免在配置文件中写死密码，利用 `bw` CLI 动态获取：
1.  **基本语法**：在 `.tmpl` 模板文件中使用：
    `password = {{ (bitwarden "item" "my-password-uuid").login.password }}`
2.  **工作流**：
    *   确保已安装 `bw` 且已登录 (`bw login`)。
    *   在应用配置前执行 `bw unlock` 获取会话密钥。

## 6. 高级技巧
*   **增量添加目录**：`chezmoi add ~/.config/xxx`。
*   **忽略文件**：修改 `.chezmoignore` 排除不需要同步的文件。
*   **模板功能**：使用 `.tmpl` 后缀配合 `{{ .chezmoi.os }}` 等变量。
