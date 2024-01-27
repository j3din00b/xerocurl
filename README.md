# Xero CURL

This is the repository that the setup curl scripts pulls down.

## Dear Contributors:

To update the contents of this repository, please do the following:

**- Install Rust**  (select option 2)
```bash
sudo pacman -S rustup cargo
rustup default stable
```

**- Compile Binary & Pull down Scripts**
```bash
cd contents
./update_contents.sh
cd ..
```
