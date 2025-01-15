class Url < ApplicationRecord
    validates :url_original, presence: true
    validates :url_shortener, presence: true

    before_validation :generate_url_from_original
    before_validation :fetch_page_title
    ALPHABET = "ABCDEFGHIJKMNOPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz0123456789".chars.freeze

    private

    def generate_url_from_original
        length = 1
        loop do
            self.url_shortener = SecureRandom.random_bytes(length).each_byte.map { |byte| ALPHABET[byte % 62]  }.join
            break unless Url.exists?(url_shortener: url_shortener)
            length += 1
        end
    end

    def fetch_page_title
        require "nokogiri"
        require "open-uri"

        begin
            documento = Nokogiri::HTML(URI.open(url_original))
            self.page_title = documento.title
        rescue StantardError => e
            self.page_title = "Titulo no encontrado"
        end
    end
end
