defmodule Redis.Command do
  import Redis.Coder

  def keys(pattern) do
    ["KEYS", pattern]
  end

  def get(key) do
    ["GET", encode(key)]
  end

  def multi_get(keys) do
    ["MGET" | Enum.map(keys, &encode/1)]
  end

  def set(key, val, opts \\ []) do
    ["SET", encode(key), encode(val) | opts]
  end

  def delete(key) do
    ["DEL", encode(key)]
  end

  def zadd(set, score, term, opts \\ []) do
    ["ZADD", encode(set), score, encode(term) | opts]
  end

  def zadd_timeseries(set, term, opts \\ []) do
    zadd(set, System.system_time(:millisecond), term, opts)
  end

  def zscore(set, term) do
    ["ZSCORE", encode(set), encode(term)]
  end

  def zrange(set, min, max, opts \\ []) do
    ["ZRANGE", encode(set), min, max | opts]
  end

  def zrange_all(set, opts \\ []) do
    zrange(set, "0", "-1", opts)
  end

  def zrange_by_score(set, min, max, opts \\ []) do
    ["ZRANGEBYSCORE", encode(set), min, max | opts]
  end

  def zrange_by_score_gt(set, score, opts \\ []) do
    zrange_by_score(set, "(#{score}", "+inf", opts)
  end

  def zrange_by_score_lt(set, score, opts \\ []) do
    zrange_by_score(set, "-inf", "(#{score}", opts)
  end

  def zremrange_by_score(set, min, max, opts \\ []) do
    ["ZREMRANGEBYSCORE", encode(set), min, max | opts]
  end

  def zremrange_by_score_gt(set, score, opts \\ []) do
    zremrange_by_score(set, ")#{score}", "+inf", opts)
  end

  def zremrange_by_score_lt(set, score, opts \\ []) do
    zremrange_by_score(set, "-inf", "(#{score}", opts)
  end
end
