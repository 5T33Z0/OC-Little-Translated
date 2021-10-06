# HP Special `0D6D` patch

- See `0D6D Patch` for more information about the `0D/6D Patch
- Some HP machines with `_PRW` methods for some parts of `ACPI` (related to `0D6D`) are as follows:

	```
	Method (_PRW, 0, NotSerialized)
   {
      Local0 = Package (0x02)
      {
          Zero,
          Zero
      }
      Local0 [Zero] = 0x6D
      If ((USWE == One)) /* Note that USWE */
      {
          Local0 [One] = 0x03
      }
      Return (Local0)
  	}
```

  This case can be completed with the ``0D/6D patch`` using the ``preset variables method``, e.g.

  ```
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          USWE = 0
      }
  }
  ```

- Example: ***SSDT-0D6D-HP*** for `HP 840 G3`. Patches the `_PRW` return value for `XHC`, `GLAN`.

**NOTE**: Refer to the sample file for other machines with similar conditions.
