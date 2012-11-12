class ProjectsController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_filter :authenticate_user!

  load_resource

  def show
    @project = Project.find_by_id(params[:id])
    @experiments = @project.experiments.order(sort_column + " " + sort_direction).paginate(page: params[:page]) unless @project.nil?
  end

  def edit
    @project = Project.find_by_id(params[:id])
  end

  def update
    @project = Project.find_by_id(params[:id])
    @project.update_attributes(params[:project])

    if @project.save
      flash[:notice] = "Project updated."
      redirect_to project_path(@project)
    else
      flash[:alert] = "Please fill in all mandatory fields."
      render 'edit'
    end
  end

  def cancel_update
    flash[:alert] = "Project was not updated."
    redirect_to root_path
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.create(params[:project].merge(:user_id => current_user.id))

    if @project.save
      flash[:notice] = "Project created."
      redirect_to root_path
    else
      flash[:alert] = "Please fill in all mandatory fields."
      render 'new'
    end
  end

  def cancel
    flash[:alert] = "Project was not created."
    redirect_to root_path
  end

  def project_data
    project = Project.find_by_id(params[:id])
    render :json => project.to_json_data
  end

  def summary

    # generate the metadata file
    csv = Tempfile.new("metadata.csv")
    CSV.open(csv.path, "wb") do |csv|

      header = ["Project ID",
                "Project Name",
                "Project Create date",
                "Project Creator Staff Student/ID",
                "Project Creator First Name",
                "Project Creator Last Name",
                "Project Creator Email",
                "Project Creator Schools/Institute",
                "Project Supervisor First Name",
                "Project Supervisor Last Name",
                "Project Description",
                "Funded by Agency",
                "Funding Agency",
                "Other Funding Agency",
                "Experiment ID",
                "Experiment Name",
                "Experiment Date",
                "Experiment Start Time",
                "Experiment End Time",
                "Experiment Duration (seconds)",
                "Experiment Owner First Name",
                "Experiment Owner Last Name",
                "Instrument Name",
                "Lab Book No.",
                "Page No.",
                "Cell Type/Tissue",
                "Experiment Type",
                "Slides",
                "Dishes",
                "Multiwell Chambers",
                "Other Apparatus",
                "Specify Other Apparatus"]

      fp_count = ActiveRecord::Base.connection.execute("select count(*) from experiments_fluorescent_proteins group by experiment_id order by count desc limit 1").entries.first
      sd_count = ActiveRecord::Base.connection.execute("select count(*) from experiments_specific_dyes group by experiment_id order by count desc limit 1").entries.first
      iv_count = ActiveRecord::Base.connection.execute("select count(*) from experiments_immunofluorescences group by experiment_id order by count desc limit 1").entries.first

      fp_count.nil? ? fp_count = 0 : fp_count = fp_count["count"].to_i
      sd_count.nil? ? sd_count = 0 : sd_count = sd_count["count"].to_i
      iv_count.nil? ? iv_count = 0 : iv_count = iv_count["count"].to_i

      header << "Has Fluorescent Proteins?"
      fp_count.times do |i|
        header << "Fluorescent Protein #{i+1}"
      end

      header << "Has Specific Dyes?"
      sd_count.times do |i|
        header << "Specific Dye #{i+1}"
      end

      header << "Has Immunofluorescence?"
      iv_count.times do |i|
        header << "Immunofluorescence #{i+1}"
      end

      header += ["Experiment Failed?", "Instrument Failed?", "Instrument Failed Reason", "Other Comments"]

      csv << header

      Project.all.each do |project|
        researcher = project.user
        supervisor = project.supervisor

        project.experiments.each do |experiment|

          owner = experiment.user
          values = [project.id,
                    project.name || "",
                    localize(project.created_at, :format => :short),
                    researcher.user_id,
                    researcher.first_name,
                    researcher.last_name,
                    researcher.email,
                    researcher.department,
                    supervisor.first_name,
                    supervisor.last_name,
                    project.description || "",
                    project.funded_by_agency? ? "Yes" : "No",
                    project.agency || "",
                    project.other_agency || "",
                    experiment.expt_id,
                    experiment.expt_name || "",
                    localize(experiment.created_at, :format => :short),
                    experiment.created_at.strftime("%H:%M:%S"),
                    experiment.end_time.present? ? experiment.end_time.strftime("%H:%M:%S") : "-",
                    experiment.end_time.present? ? "#{(experiment.end_time - experiment.created_at).round}" : "-",
                    owner.first_name,
                    owner.last_name,
                    experiment.instrument || "",
                    experiment.lab_book_no || "",
                    experiment.page_no || "",
                    experiment.cell_type_or_tissue || "",
                    experiment.expt_type || "",
                    experiment.slides? ? "Yes" : "No",
                    experiment.dishes? ? "Yes" : "No",
                    experiment.multiwell_chambers? ? "Yes" : "No",
                    experiment.other? ? "Yes" : "No",
                    experiment.other_text || ""]

          if experiment.has_fluorescent_proteins?
            values << "Yes"
            values += experiment.fluorescent_proteins.pluck(:name)
            values += [nil] * (fp_count - experiment.fluorescent_proteins.count)
          else
            values << "No"
            values += [nil] * fp_count
          end

          if experiment.has_specific_dyes?
            values << "Yes"
            values += experiment.specific_dyes.pluck(:name)
            values += [nil] * (sd_count - experiment.specific_dyes.count)
          else
            values << "No"
            values += [nil] * sd_count
          end

          if experiment.has_immunofluorescence?
            values << "Yes"
            values += experiment.immunofluorescences.pluck(:name)
            values += [nil] * (iv_count - experiment.immunofluorescences.count)
          else
            values << "No"
            values += [nil] * iv_count
          end

          if experiment.experiment_feedback
            values += [experiment.experiment_feedback.experiment_failed? ? "Yes" : "No",
                       experiment.experiment_feedback.instrument_failed? ? "Yes" : "No",
                       experiment.experiment_feedback.instrument_failed_reason,
                       experiment.experiment_feedback.other_comments]

          end

          csv << values
        end
      end

    end



    file_name = Time.now.strftime("summary_report_%Y%m%d%H%M%S.csv")

    send_file csv.path, :type => 'text/csv',
              :disposition => 'attachment',
              :filename => file_name
  end

  private

  def sort_column
    Experiment.column_names.include?(params[:sort]) ? params[:sort] : "expt_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
