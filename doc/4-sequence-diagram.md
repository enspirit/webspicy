```
@startuml
participant Tester
participant Client
participant Result
participant PrePost
participant Config
Tester -> Config : before_all(Scope, Client)
group * test case
  Tester -> Config   : before_each(TestCase, Client)
  Tester -> Client   : instrument(TestCase)
  group * pre/post/err
    Client -> PrePost  : instrument(TestCase, Client)
  end
  Client -> Config   : instrument(TestCase, Client)
  Tester -> Client   : call(TestCase)
  Tester -> Result   : check_response!
  Tester -> Result   : check_output!
  Tester -> Result   : check_assertions!
  Tester -> Result   : check_postconditions!
  group * post/err
    Result -> PrePost  : check(Invocation)
  end
  Tester -> Config   : after_each(TestCase, Client)
end
Tester -> Config : after_all(Scope, Client)
@enduml
```

                    ┌──────┐              ┌──────┐          ┌──────┐          ┌───────┐          ┌──────┐          
                    │Tester│              │Client│          │Result│          │PrePost│          │Config│          
                    └──┬───┘              └──┬───┘          └──┬───┘          └───┬───┘          └──┬───┘          
                       │                     │                 │                  │                 │              
                       │                     │    before_all(Scope, Client)       │                 │              
                       │───────────────────────────────────────────────────────────────────────────>│              
                       │                     │                 │                  │                 │              
          ╔══════════════╤═══════════════════╪═════════════════╪══════════════════╪═════════════════╪═════════════╗
          ║ * TEST CASE  │                   │                 │                  │                 │             ║
          ╟──────────────┘                   │  before_each(TestCase, Client)     │                 │             ║
          ║            │───────────────────────────────────────────────────────────────────────────>│             ║
          ║            │                     │                 │                  │                 │             ║
          ║            │ instrument(TestCase)│                 │                  │                 │             ║
          ║            │────────────────────>│                 │                  │                 │             ║
          ║            │                     │                 │                  │                 │             ║
          ║            │        ╔════════════╪════╤════════════╪══════════════════╪═════════════╗   │             ║
          ║            │        ║ * PRE/POST/ERR  │            │                  │             ║   │             ║
          ║            │        ╟─────────────────┘            │                  │             ║   │             ║
          ║            │        ║            │    instrument(TestCase, Client)    │             ║   │             ║
          ║            │        ║            │───────────────────────────────────>│             ║   │             ║
          ║            │        ╚════════════╪═════════════════╪══════════════════╪═════════════╝   │             ║
          ║            │                     │                 │                  │                 │             ║
          ║            │                     │             instrument(TestCase, Client)             │             ║
          ║            │                     │─────────────────────────────────────────────────────>│             ║
          ║            │                     │                 │                  │                 │             ║
          ║            │    call(TestCase)   │                 │                  │                 │             ║
          ║            │────────────────────>│                 │                  │                 │             ║
          ║            │                     │                 │                  │                 │             ║
          ║            │            check_response!            │                  │                 │             ║
          ║            │──────────────────────────────────────>│                  │                 │             ║
          ║            │             check_output!             │                  │                 │             ║
          ║            │──────────────────────────────────────>│                  │                 │             ║
          ║            │           check_assertions!           │                  │                 │             ║
          ║            │──────────────────────────────────────>│                  │                 │             ║
          ║            │         check_postconditions!         │                  │                 │             ║
          ║            │──────────────────────────────────────>│                  │                 │             ║
          ║            │                     │                 │                  │                 │             ║
          ║            │                     │    ╔═════════════╤═════════════════╪═════════════╗   │             ║
          ║            │                     │    ║ * POST/ERR  │                 │             ║   │             ║
          ║            │                     │    ╟─────────────┘                 │             ║   │             ║
          ║            │                     │    ║            │ check(Invocation)│             ║   │             ║
          ║            │                     │    ║            │─────────────────>│             ║   │             ║
          ║            │                     │    ╚════════════╪══════════════════╪═════════════╝   │             ║
          ║            │                     │                 │                  │                 │             ║
          ║            │                     │  after_each(TestCase, Client)      │                 │             ║
          ║            │───────────────────────────────────────────────────────────────────────────>│             ║
          ╚════════════╪═════════════════════╪═════════════════╪══════════════════╪═════════════════╪═════════════╝
                       │                     │                 │                  │                 │              
                       │                     │    after_all(Scope, Client)        │                 │              
                       │───────────────────────────────────────────────────────────────────────────>│              
                    ┌──┴───┐              ┌──┴───┐          ┌──┴───┐          ┌───┴───┐          ┌──┴───┐          
                    │Tester│              │Client│          │Result│          │PrePost│          │Config│          
                    └──────┘              └──────┘          └──────┘          └───────┘          └──────┘           