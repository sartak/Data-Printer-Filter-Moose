Data::Printer ♥ Moose

    My::Moosey::RealPerson  {
        Parents          My::Moosey::Person
        Linear @ISA      My::Moosey::RealPerson, My::Moosey::Person, Moose::Object
        Local Roles      Role::IsPhysicalThing, Role::HasHeight, Role::HasWidth
        Inherited Roles  Role::HasName
        Local Attributes  {
            width  {
                value  6
                isa    Int
            }
            height  {
                value  12
                isa    Int
            }
        }
        Inherited Attributes  {
            name  {
                value  "box man"
                isa    Str
            }
        }
    }
