Data::Printer ♥ Moose

    My::Moosey::RealPerson  {
        Parents          My::Moosey::Person
        Linear @ISA      My::Moosey::RealPerson, My::Moosey::Person, Moose::Object
        Local Roles      Role::IsPhysicalThing, Role::HasHeight, Role::HasWidth
        Inherited Roles  Role::HasName
        Local Attributes  {
            width  {
                Value  6
                isa    Int
            }
            height  {
                Value  12
                isa    Int
            }
        }
        Inherited Attributes  {
            name  {
                Value  "box man"
                isa    Str
            }
        }
    }
