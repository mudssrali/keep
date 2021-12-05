defmodule KeepWeb.GraphQL.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(KeepWeb.GraphQL.TodoTypes)

  query do
    import_fields(:todo_queries)
  end

  mutation do
    import_fields(:todo_mutations)
  end
end
