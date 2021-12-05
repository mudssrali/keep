defmodule KeepWeb.GraphQL.Errors do
    @moduledoc """
    Defines common GraphQL error responses
    """
    defmacro __using__(_) do
        quote do
            @not_found {
                :error,
                %{
                    code: :not_found,
                    message: "Not found"
                }
            }
        end
    end
end