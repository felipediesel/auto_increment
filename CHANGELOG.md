# Changelog

## [1.6.2] - 2024-05-18

### Fixed

- Bumped rexml from 3.2.6 to 3.2.8 for security

## [1.6.1] - 2024-01-02

### Changed

- Removed deprecation warning for `scope` parameter

## [1.6.0] - 2024-01-02

### Added

- Support for Rails 6.1.0 and 7.0.3.1

### Deprecated

- `scope:` parameter is deprecated in favor of `model_scope:`

### Changed

- Migrated CI from Travis to CircleCI
- Updated supported Rails versions

## [1.5.1] - 2019-03-14

### Added

- Support for Rails 6

### Changed

- Updated Ruby versions to 2.5.4 and 2.6.2

## [1.5.0] - 2018-01-21

### Added

- `model_scope` option to apply ActiveRecord scopes before computing the maximum value
- Support for Rails 5.2

### Changed

- Renamed `model_scopes` to `model_scope`

## [1.4.1] - 2017-05-04

### Added

- Support for Rails 5.1 via Appraisal

## [1.4.0] - 2016-11-04

### Added

- `before:` option to choose which callback to use (`:create`, `:save`, `:validation`)
- Rubocop linting

## [1.3.0] - 2016-07-19

### Added

- Support for Rails 5 via Appraisal

## [1.2.0] - 2015-06-18

### Changed

- Breaking: arguments split into separate `column` and `options` parameters
- Lock default changed to query object

## [1.1.1] - 2015-05-05

### Fixed

- Minor internal cleanup

## [1.1.0] - 2015-03-26

### Added

- `lock:` option for thread-safe increments
- Initial implementation of scoped sequences

## [1.0.0] - 2014-04-15

### Added

- Initial release
- Auto-increment integer columns with `before_create` callback
- Custom starting value via `initial:` option
- `force:` option to overwrite existing values
