# gitlab_release plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-gitlab_release)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/andreadelfante/fastlane-plugin-gitlab_release/blob/master/LICENSE)
[![Gem](https://img.shields.io/gem/v/gitlab-release-tools.svg?style=flat)](https://rubygems.org/gems/fastlane-plugin-gitlab_release)
[![Build Status](https://travis-ci.org/andreadelfante/gitlab-release-tools.svg?branch=master)](https://travis-ci.org/andreadelfante/fastlane-plugin-gitlab_release)

The Fastlane wrapper of [gitlab-release-tools](https://github.com/andreadelfante/gitlab-release-tools).

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-gitlab_release`, add it to your project by running:

```bash
fastlane add_plugin gitlab_release
```

## Example

```ruby
version_name = '1.0'

changelog = gitlab_release_changelog(version_name: version_name) # for more fastlane action gitlab_release_changelog
puts("Changelog with no reference:\n#{changelog}") # or changelog.to_s
puts("Changelog with reference:\n#{changelog.to_s_with_reference}")

gitlab_release_close(version_name: version_name, entries: changelog)  # for more fastlane action gitlab_release_close
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
