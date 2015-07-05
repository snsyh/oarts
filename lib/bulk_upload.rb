class BulkUpload
  require 'zip/zip'
  require 'rubygems'
  require 'rmagick'

  attr_accessor :filelist

  ZIP_DIR="fileio/zip"
  MELT_DIR="fileio/melt"
  
  def resize(filepath)
        # 対象の画像ファイルの読み込み
        original = Magick::Image.read(filepath.to_s).first
        # 比率でリサイズ
        image = original.resize_to_fit(300, 300)

        ##文字を埋め込んで、シャドウをつけた。
        draw = Magick::Draw.new
        draw.annotate(image, 0, 0, 4, 4, "SAMPLE") {
          self.font = 'Library/Fonts/Times New Roman.ttf'
          self.pointsize = 35
          self.gravity = Magick::CenterGravity
          self.fill = 'black'
          self.stroke = 'transparent'
        }

        draw.annotate(image, 0, 0, 5, 5, "SAMPLE") {
          self.font = 'Library/Fonts/Times New Roman.ttf'
          self.pointsize = 35
          self.gravity = Magick::CenterGravity
          self.fill = 'white'
          self.stroke = 'transparent'
        }

        draw.annotate(image, 0, 0, 4, 4, "© 2015 a.sone") {
          self.font = 'Library/Fonts/Times New Roman.ttf'
          self.pointsize = 14
          self.gravity = Magick::SouthEastGravity
          self.stroke = 'transparent'
          self.fill = 'black'
        }

        draw.annotate(image, 0, 0, 5, 5, "© 2015 a.sone") {
          self.font = 'Library/Fonts/Times New Roman.ttf'
          self.pointsize = 14
          self.gravity = Magick::SouthEastGravity
          self.stroke = 'transparent'
          self.fill = 'white'
        }

        image.write(filepath.to_s)
    
  end

  def bulk_resize(rails_root, filename)
    @filelist = []
    Zip::File.open("#{rails_root}/#{ZIP_DIR}/#{filename}") do |zip|
      zip.each do |entry|
        zip.extract(entry, "#{rails_root}/#{MELT_DIR}/" + entry.to_s) { true }
        resize("#{rails_root}/#{MELT_DIR}/" + entry.to_s)
        @filelist.push("#{rails_root}/#{MELT_DIR}/#{entry.name}")
      end
    end
  end

end
