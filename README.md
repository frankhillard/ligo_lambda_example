# ligo_lambda_example
Example of a Tezos smart contract (using lambda)

The starmap smart contract is a dummy-referential of celestial bobies of the solar system. The goal is to classify celestial bodies into categories such as of planets, asteroid, and dwarf planets ... 
In this smart contract the category is deduced from mass  and distance to the sun. Actually in 2006, the rule for a planet has been changed and Pluto lost its title of planet. 
Once deployed a smart contract is supposed to be immutable. But sometimes we need to change the logic of a smart contract without losing  its storage containing all data. The good practice in LIGO is to implement the logic in a lambda (inside the storage). In our case, the underlying algorithm to classify planets may change, we must implement it in a lambda.

## Comments

Notice that a celestial body contains 
* a name 
* a mass 
* a distance to the sun.

Notice that the smart contract implements 2 entry points *AddPlanet* and *DeduceCategoryChange*

Notice that when changing the classification algorithm it updates all existing entries.

Possible categories are :
PLANET, ASTEROID, STAR, GIANT, FAR, BELT, DWARF



## Command lines (using ligo compiler)


Prepare a storage expression (in Michelson format) with ligo compile-storage command line:
```
ligo compile-storage starmap.mligo main '{name="Sol";func=( fun (p : planet) -> if p.mass > 100n then PLANET else ASTEROID);celestial_bodies=Map.literal [("earth", {dist=100n;mass=100n;category=PLANET}); ("saturne", {dist=953n;mass=9500n;category=PLANET}); ("jupiter", {dist=520n;mass=31700n;category=PLANET}); ("pluto", {dist=3988n;mass=5n;category=PLANET}); ("sun", {dist=0n;mass=10000000n;category=PLANET})]}'
```

Simulate execution of *AddPlanet* entry point
```
ligo dry-run starmap.mligo main 'AddPlanet({name="mars";distance=150n;mass=10n})' '{name="Sol";func=( fun (p : planet) -> if p.mass > 5n then PLANET else ASTEROID);celestial_bodies=Map.literal [("earth", {dist=100n;mass=100n;category=PLANET}); ("sun", {dist=0n;mass=10000000n;category=PLANET})]}'
```

```
ligo dry-run starmap.mligo main 'AddPlanet({name="mars";distance=150n;mass=10n})' '{name="Sol";func=(fun (p : planet) -> if p.dist=0n then STAR else if p.mass > 900n then GIANT else if p.dist > 1000n && p.dist < 1500n && p.mass < 2n then BELT else if p.mass > 5n then PLANET else if p.mass < 5n then DWARF else if p.dist > 500n then FAR else ASTEROID);celestial_bodies=Map.literal [("earth", {dist=100n;mass=100n;category=PLANET}); ("saturne", {dist=953n;mass=9500n;category=PLANET}); ("jupiter", {dist=520n;mass=31700n;category=PLANET}); ("pluto", {dist=3988n;mass=4n;category=PLANET}); ("sun", {dist=0n;mass=10000000n;category=PLANET})]}'
```

Simulate execution of *DoNothing* entry point:
```
// ligo dry-run starmap.mligo main 'DoNothing' '{name="Sol";func=( fun (p : planet) -> if p.mass > 100n then PLANET else ASTEROID);celestial_bodies=Map.literal [("earth", {dist=100n;mass=1000n;category=PLANET}); ("pluto", {dist=3988n;mass=10n;category=PLANET}); ("sun", {dist=0n;mass=1000000n;category=PLANET})]}'
```

Simulate execution of *DeduceCategoryChange* entry point (for changing classification algorithm):
```
ligo dry-run starmap.mligo main 'DeduceCategoryChange(fun (p : planet) -> if p.dist=0n then STAR else if p.mass > 900n then GIANT else if p.dist > 1000n && p.dist < 1500n && p.mass < 2n then BELT else if p.mass > 10n then PLANET else if p.mass < 5n then DWARF else if p.dist > 500n then FAR else ASTEROID)' '{name="Sol";func=( fun (p : planet) -> if p.mass > 100n then PLANET else ASTEROID);celestial_bodies=Map.literal [("earth", {dist=100n;mass=100n;category=PLANET}); ("saturne", {dist=953n;mass=9500n;category=PLANET}); ("jupiter", {dist=520n;mass=31700n;category=PLANET}); ("pluto", {dist=3988n;mass=4n;category=PLANET}); ("sun", {dist=0n;mass=10000000n;category=PLANET})]}'
```

```
ligo dry-run starmap.mligo main 'DeduceCategoryChange(fun (p : planet) -> if p.dist=0n then STAR else if p.mass > 900n then GIANT else if p.dist > 1000n && p.dist < 1500n && p.mass < 2n then BELT else if p.mass > 10n then PLANET else if p.mass < 5n then DWARF else if p.dist > 500n then FAR else ASTEROID)' '{name="Sol";func=(fun (p : planet) -> if p.dist=0n then STAR else if p.mass > 900n then GIANT else if p.dist > 1000n && p.dist < 1500n && p.mass < 2n then BELT else if p.mass > 5n then PLANET else if p.mass < 5n then DWARF else if p.dist > 500n then FAR else ASTEROID);celestial_bodies=Map.literal [("earth", {dist=100n;mass=100n;category=PLANET}); ("saturne", {dist=953n;mass=9500n;category=PLANET}); ("jupiter", {dist=520n;mass=31700n;category=PLANET}); ("pluto", {dist=3988n;mass=4n;category=PLANET}); ("sun", {dist=0n;mass=10000000n;category=PLANET})]}'
```