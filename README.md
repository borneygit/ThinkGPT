# GPT 客户端项目

这是一个使用 Flutter 构建的 GPT 客户端项目，旨在实现与 AI 的对话功能。本项目采用了 Clean Architecture
架构，支持主题和多语言切换、聊天历史管理等功能，便于日常学习和使用。

## 功能概述

- **AI 聊天**：实现与 GPT 的对话交流功能。
- **聊天历史管理**：保存和查看聊天记录，支持历史管理。
- **多语言支持**：实现了多语言切换，提升国际化体验。
- **主题切换**：支持应用主题的动态切换，包含深色和浅色模式。

## 关键技术栈

- **Flutter**：主要技术栈，用于开发跨平台的桌面客户端。
- **Clean Architecture**：采用分层架构，确保代码结构清晰，便于维护和扩展。
- **Bloc**：用于状态管理，确保状态变更的可追溯性和稳定性。
- **Melos**：进行项目模块化管理，便于子库的开发和协作。
- **Get_it & Injectable**：用于依赖注入，提升代码的解耦性和测试性。
- **Floor**: 用于数据库操作，提供数据持久化功能。

## 项目结构

项目采用 **Clean Architecture** 分层，每一层有独立的职责：

- **app**：应用层，负责 UI 和路由管理。
- **domain**：领域层，定义业务逻辑和接口。
- **data**：数据层，负责数据的获取与持久化。
- **resources**：资源管理，包括字符资源和图标。
- **initializer**: 应用初始化，包括配置和依赖注入。
- **shared**：共享模块，包含跨层使用的工具和常量。

各模块通过 [Melos](https://github.com/invertase/melos) 进行管理，方便独立开发和依赖管理。

## 安装与运行

1. 确保已经安装了 Flutter 和 Melos。
2. 克隆项目并进入目录：
   ```bash
   git clone <repository-url>
   cd <project-directory>
   melos bootstrap # 安装依赖和子模块
   make gen_res # 生成字符资源
   make build # build_runner生成文件
   ```
