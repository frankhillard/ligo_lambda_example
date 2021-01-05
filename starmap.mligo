type distance_to_sun = nat
type planet_type = PLANET | ASTEROID | STAR | GIANT | FAR | BELT | DWARF
type planet = {
  dist : distance_to_sun;
  mass : nat;
  category : planet_type
}
type planets = (string, planet) map
type storage = {
  name : string;
  func : (planet) -> planet_type;
  celestial_bodies : planets
}
type return = (operation list * storage)
type addplanet_param = {
  name : string;
  distance : nat;
  mass : nat
}
type parameter = DeduceCategoryChange of (planet) -> planet_type | AddPlanet of addplanet_param | DoNothing

let addPlanet (input, store : addplanet_param * storage) : return =
    let modified : planets = match Map.find_opt input.name store.celestial_bodies with
       Some (p) -> (failwith("planet already exist") : planets)
     | None -> 
      let catg = store.func {dist=input.distance;mass=input.mass;category=STAR} in
      Map.add input.name {dist=input.distance;mass=input.mass;category=catg} store.celestial_bodies
    in
    (([] : operation list), {name=store.name;func=store.func;celestial_bodies=modified})

let deduceCategoryChange (f,store : ((planet) -> planet_type) * storage) : return =
  let applyDeduceCatg = fun (name,p : string * planet) ->
      {dist=p.dist;mass=p.mass;category=f p} in
  let modified : planets = Map.map applyDeduceCatg store.celestial_bodies in
  (([] : operation list), {name=store.name;func=f;celestial_bodies=modified})

let main ((action, store) : (parameter * storage)) : return =
  match (action) with
    AddPlanet (input) -> addPlanet ((input,store))
  | DeduceCategoryChange (f) -> deduceCategoryChange ((f,store))
  | DoNothing -> (([] : operation list),store)
