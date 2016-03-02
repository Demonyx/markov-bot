class MarkovChain
  START_TOKEN = Object.new
  END_TOKEN = Object.new

  def initialize n
    @n = n
    @table = Hash.new { |hash, key| hash[key] = Hash.new { |inner_hash, inner_key| inner_hash[inner_key] = 0 } }
  end

  def train corpus
    tokens = tokenize corpus

    tokens.each_cons(@n+1) do |key|
      @table[key[0...-1]][key.last] += 1
    end
  end

  def generate
    chain = [START_TOKEN] * @n

    while chain.last != END_TOKEN
      chain << weighted_choice(@table.fetch(chain.last(@n)))
    end
    chain[@n...-1].join " "
  end

  private

  def tokenize corpus
    ([START_TOKEN] * @n) + corpus.split + [END_TOKEN]
  end

  def weighted_choice weights
    total = weights.values.reduce(&:+)
    choice = Random.new.rand(1..total)

    cumulative = 0
    weights.each do |key, value|
      cumulative += value

      if choice <= cumulative
        return key
      end
    end

    #in case no key is returned in the loop
    raise
  end
end

