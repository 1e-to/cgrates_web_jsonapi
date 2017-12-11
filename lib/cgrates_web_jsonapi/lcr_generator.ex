defmodule CgratesWebJsonapi.LcrGenerator do
  alias CgratesWebJsonapi.TpDestination
  alias CgratesWebJsonapi.TpDestinationRate
  alias CgratesWebJsonapi.TpLcrRule
  alias CgratesWebJsonapi.TpRatingPlan
  alias CgratesWebJsonapi.TpRatingProfile
  alias CgratesWebJsonapi.Repo

  import Ecto.Query

  use EctoConditionals, repo: CgratesWebJsonapi.Repo

  def generate(rating_plan_tags, options) do
    upsert_default_lcr_rule options

    rating_plan_tags
    |> Enum.each(fn (tag)-> upsert_default_ratint_profile_for(tag, options) end)

    partial_supported_dst_query(rating_plan_tags)
    |> Repo.all()
    |> Enum.each(fn (dst_tag) ->
      create_lcr_for_dst dst_tag, rating_plan_tags, options
    end)
  end

  defp upsert_default_lcr_rule(options) do
    %TpLcrRule{} |> Map.merge(options) |> upsert_by([:rp_category])
  end

  defp upsert_default_ratint_profile_for(rating_plan_tag, options) do
    %TpRatingProfile{rating_plan_tag: rating_plan_tag, tag: "#{rating_plan_tag}_default"}
    |> Map.merge(options |> Map.take "tenant", "activation_time", "direction")
    |> upsert_by([:tag])
  end

  defp partial_supported_dst_query(rating_plan_tags) do
    from d in TpDestinationRate,
      join: rp in TpRatingPlan, on: rp.destrates_tag == d.tag,
      group_by: d.destinations_tag,
      having: count(rp.tag) == ^length(rating_plan_tags)
      select: d.destinations_tag
  end

  defp create_lcr_for_dst(dst_tag, rating_plan_tags, options) do
    %TpLcrRule{}
    |> Map.merge(options |> Map.merge(%{rp_category: "lcr_for_#{dst_tag}"}))
    |> upsert_by([:rp_category])

    plans_supports_dst(dst_tag, rating_plan_tags)
    |> Enum.each(fn (rp) ->
      %TpRatingProfile{rating_plan_tag: rating_plan_tag, tag: "#{rating_plan_tag}_for_#{dst_tag}"}
      |> Map.merge(options |> Map.take "tenant", "activation_time", "direction")
      |> upsert_by([:tag])
    end)
  end

  defp plans_supports_dst(dst_tag, rating_plan_tags) do
    TpDestinationRate
    |> join([d], p in TpRatingPlan, rp.destrates_tag == d.tag)
    |> where([d,p], d.destinations_tag == ^dst_tag)
    |> select([d,p], p.tag)
    |> Repo.all()
  end
end
