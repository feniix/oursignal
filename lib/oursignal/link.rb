module Oursignal
  class Link
    store :links
    attribute :id,                Swift::Type::Integer, serial: true, key: true
    attribute :url,               Swift::Type::String
    attribute :title,             Swift::Type::String
    attribute :referrers,         Swift::Type::String
    attribute :score_delicious,   Swift::Type::Float,   default: 0
    attribute :score_digg,        Swift::Type::Float,   default: 0
    attribute :score_frequency,   Swift::Type::Float,   default: 0
    attribute :score_freshness,   Swift::Type::Float,   default: 0
    attribute :score_reddit,      Swift::Type::Float,   default: 0
    attribute :score_swarm,       Swift::Type::Float,   default: 0
    attribute :score_twitter,     Swift::Type::Float,   default: 0
    attribute :score_ycombinator, Swift::Type::Float,   default: 0
    attribute :score_average,     Swift::Type::Float,   default: 0
    attribute :score,             Swift::Type::Float,   default: 0
    attribute :velocity_average,  Swift::Type::Float,   default: 0
    attribute :velocity,          Swift::Type::Float,   default: 0
    attribute :score_at,          Swift::Type::Time
    attribute :referred_at,       Swift::Type::Time,    default: proc{ Time.now }
    attribute :updated_at,        Swift::Type::Time,    default: proc{ Time.now }
    attribute :created_at,        Swift::Type::Time,    default: proc{ Time.now }
  end # Link
end # Oursignal
