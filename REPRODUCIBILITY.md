# Reproducibility notes

## Reference environment

- Python: 3.12
- SymPy: 1.14.0
- Operating system in CI: current GitHub-hosted Ubuntu runner

Only `03-consecutive-squares` and `05-chebyshev-mod30` require SymPy. The scripts in
`09-closed-routes` use the Python standard library only.

## Status vocabulary

- **exact finite check**: integer/rational/Gaussian-integer arithmetic with blocking assertions;
- **numerical finite check**: a finite enumeration using floating complex roots of unity and a
  stated tolerance;
- **truncated numerical evaluation**: a finite truncation of an infinite product;
- **conditional/conjectural**: a mathematical interpretation depending on an explicitly named
  hypothesis such as Bateman–Horn or GRH + linear independence.

The repository does not silently promote one category into another.

## Commands

```bash
python -m pip install -r requirements.txt
bash VERIFY_LOCAL.sh
```

The longest public calculations are the prime enumerations in folders 03 and 05.
