# dec2hex

dec2hex is a small helper for converting decimal numbers into hexadecimal numbers. It's written in pure NASM for macOS.

## Usage

`d2h <number>`

```bash
$ d2h 57005
deadbe
```

## Building

Make sure to have `make` and NASM installed.

```bash
git clone https://github.com/SarahIsWeird/dec2hex
cd dec2hex
make
sudo make install
```
