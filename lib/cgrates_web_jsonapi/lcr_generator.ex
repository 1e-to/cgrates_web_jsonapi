defmodule CgratesWebJsonapi.LcrGenerator do
  alias CgratesWebJsonapi.TpDestination
  alias CgratesWebJsonapi.TpLcrRule
  alias CgratesWebJsonapi.TpRatingProfile
  alias CgratesWebJsonapi.Repo

  use EctoConditionals, repo: CgratesWebJsonapi.Repo

  def generate(rating_plan_tags, options) do
    upsert_default_lcr_rule options

    rating_plan_tags
    |> Enum.each(fn (tag)-> upsert_default_ratint_profile_for(tag, options) end)


  end

  defp upsert_default_lcr_rule(options) do
    %TpLcrRule{} |> Map.merge(options) |> upsert_by([:rp_category])
  end

  defp upsert_default_ratint_profile_for(rating_plan_tag, options) do
    %TpRatingProfile{rating_plan_tag: rating_plan_tag, tag: "#{rating_plan_tag}_default"}
    |> Map.merge(options |> Map.take "tenant", "activation_time", "direction")
    |> upsert_by([:tag])
  end
end
