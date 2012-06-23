Data::Printer ♥ Moose

    Car::Expensive  {
        Parents          Car::Basic
        Linear @ISA      Car::Expensive, Car::Basic, Moose::Object
        Local Roles      HasAirConditioning, HasSpinningRims
        Inherited Roles  Carlike, HasEngine, HasWheels
        Local Attributes  {
            obligatory_name  {
                value  "Ham Wagon"
                isa    Str
            }
            ac  {
                value  undef
                isa    Blissful
            }
            rims  {
                value  undef
                isa    Spin
            }
        }
        Inherited Attributes  {
            wheels  {
                value  undef
                isa    Wheels
            }
            engine  {
                value  undef
                isa    Engine
            }
        }
    }
