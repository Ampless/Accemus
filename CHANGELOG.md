## 0.1.3

- Added the `--json`/`-J` option for getting JSONs other than the Timetable one.
This option is temporary and might be renamed, as well as `--timetable-json`/`-j`

## 0.1.2

- `--timetable-json`/`-j` now tries to prettify the Timetable JSON, if it can't,
it behaves like before
- Much better documentation
- Fixed a bug in the HTTP request logging where if `dsbuntis` was to issue a
`POST` request (which it currently doesn't), the `Body` would not have been
logged, the `URL` twice

## 0.1.1

- Introduced an ugly hack to reduce the time from the end of `main` until the
program actually exits (by calling `exit` manually)

## 0.1.0

- First release on `pub`
- Check Git for all the work leading up to it
