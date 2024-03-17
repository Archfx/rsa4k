## RSA4k

RSA4k is a fully self contained verilog implementation of RSA 4096bits. 

### Repository Structure

```shell
.
├── readme.md
├── rtl
│   ├── modExp.v
│   ├── modInv.v
│   ├── mod.v
│   ├── mulAdd.v
│   ├── _parameter.v
│   └── rsa4k.v
├── sim.tcl
└── tb
    ├── moduls_tb.v
    └── top.v
```

### Run a simulation

```shell
git clone https://github.com/Archfx/rsa4k rsa4k
cd rsa4k
./sim.tcl
```


#### NOTE
This implementation is based on the implementation of [MonPro](https://github.com/fatestudio/RSA4096) Algorithm. All the credits related to the implementation of MonPro to the original authors of [fasteststudio](https://github.com/fatestudio).