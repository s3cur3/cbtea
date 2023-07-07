[![Build and Test](https://github.com/s3cur3/cbtea/actions/workflows/elixir-build-and-test.yml/badge.svg)](https://github.com/s3cur3/cbtea/actions/workflows/elixir-build-and-test.yml) [![Elixir Type Linting](https://github.com/s3cur3/cbtea/actions/workflows/elixir-dialyzer.yml/badge.svg?branch=main)](https://github.com/s3cur3/cbtea/actions/workflows/elixir-dialyzer.yml) [![Elixir Quality Checks](https://github.com/s3cur3/cbtea/actions/workflows/elixir-quality-checks.yml/badge.svg)](https://github.com/s3cur3/cbtea/actions/workflows/elixir-quality-checks.yml) [![codecov](https://codecov.io/gh/s3cur3/cbtea/branch/main/graph/badge.svg?token=98RJZ7WK8R)](https://codecov.io/gh/s3cur3/cbtea) [![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# CBTea 🍵

**A privacy-first cognitive behavioral therapy (CBT) app.**

CBTea provides an interface for a common exercise in CBT: the automatic, negative thought record. It's a way to help you identify and challenge negative thoughts, with the ultimate goal of changing your thinking patterns and helping you feel better.

CBTea is designed with privacy as the foremost concern. Your data is stored securely in the cloud, [soon][v1] with end-to-end encryption. There is absolutely zero tracking, analytics, or other data collection. In the future, you'll even be able to use the app without creating an account or offline.

**Warning**: CBTea is pre-public beta right now. Please don't use it for anything important, and don't assume your data will be preserved. Once we reach [v1.0][v1], we'll guarantee your data's safety.

This codebase is an Elixir re-implementation of the GPL v3 [Quirk][] React Native app. There's a demo of it in action [on the Wayback Machine][QuirkDemo].

[v1]: https://github.com/s3cur3/cbtea/issues/2
[Quirk]: https://github.com/Flaque/quirk
[QuirkDemo]: https://web.archive.org/web/20191226140443/https://www.quirk.fyi/
