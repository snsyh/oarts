ActiveAdmin.register Art do
  require "bulk_upload"
  require "date"

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end
  
  filter :id
  filter :event_date
  
  index do
    selectable_column
    column :id
    column :event_date
    column :art_image do |img|
      image_tag(img.art_image, :size => "90x60")
    end
    actions
  end

  sidebar :upload do
    render :partial => "upload"
  end

  form(:html => { :multipart => true }) do |f|
    f.inputs "Details" do
      f.input :event_date
      f.input :art_image
    end
    f.actions
  end

  controller do
    
    def create
      params[:art][:event_year] = params[:art]["event_date(1i)"]
      params[:art][:event_month] = params[:art]["event_date(2i)"].rjust(2, '0')
      params[:art][:event_day] = params[:art]["event_date(3i)"].rjust(2, '0')
      params[:art][:event_year_month] = params[:art][:event_year] + params[:art][:event_month]
      art = params[:art].permit(:userid, :username, :event_date, :art_image, :event_year_month, :event_year, :event_month, :event_day)
      Art.create(art)
      redirect_to "/admin/arts"
    end
    
    def update
      params[:art][:event_year] = params[:art]["event_date(1i)"]
      params[:art][:event_month] = params[:art]["event_date(2i)"].rjust(2, '0')
      params[:art][:event_day] = params[:art]["event_date(3i)"].rjust(2, '0')
      params[:art][:event_year_month] = params[:art][:event_year] + params[:art][:event_month]
      params[:art][:event_year_month_day] = params[:art][:event_year] + params[:art][:event_month] + params[:art][:event_day]

      art = Art.find_by(id: params[:id])
      art.userid = params[:art][:userid]
      art.username = params[:art][:username]
      art.art_image = params[:art][:art_image] if params[:art][:art_image].present?
      art.event_date = params[:art][:event_year_month_day]
      art.event_year = params[:art][:event_year]
      art.event_month = params[:art][:event_month]
      art.event_day = params[:art][:event_day]
      art.event_year_month = params[:art][:event_year_month]
      art.save

      # 対象の画像ファイルの読み込み
      BulkUpload.new.resize("#{Rails.root}/public" + art.art_image.to_s)

      redirect_to "/admin/arts"
    end
    
    def upload
        file = params[:upfile]
        zip_name = file.original_filename
        params = ['.zip', '.Zip', '.ZIP']
        File.open("#{Rails.root}/fileio/zip/#{zip_name}", 'wb') { |f| f.write(file.read)}

        b_upload = BulkUpload.new
        b_upload.bulk_resize(Rails.root, zip_name)
        b_upload.filelist.each do |img|
          art_file_name = img.split("/")
          split_column = art_file_name[art_file_name.length-1].split("_")
          yearMonthDate = split_column[0]
          user = split_column[1]
          Art.create(userid: user, username: user, event_date: yearMonthDate.split(".")[0], event_year: yearMonthDate[0,4], event_month: yearMonthDate[4,2], event_day: yearMonthDate[6,2], event_year_month: yearMonthDate[0,6], art_image: open(img))
        end
        redirect_to "/admin/arts"
    end
    
    def delete
      idList = params[:ids]
    end
    
  end

  permit_params :userid, :username, :event_date, :art_image, :event_year_month, :event_year, :event_month, :event_day
end
