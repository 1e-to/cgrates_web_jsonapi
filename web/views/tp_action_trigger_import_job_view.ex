defmodule CgratesWebJsonapi.TpActionTriggerImportJobView do
  use CgratesWebJsonapi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:id, :status]

end
