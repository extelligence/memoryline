class MemoriesController < ApplicationController
  before_filter :login_required
  before_filter :not_memory_owner_access_denied, :except => [:index, :create]

  # GET /memories
  # GET /memories.xml
  def index
    # MemoryForm作成
    # 3つのテキストボックス作成のために配列を用意しておく
    @memory_textboxes = (1..3).map do
      Memory.new
    end
    # Suggest用インデックス
    @memories_index = Memory.my_memory_index(current_user.id)

    @memories = Memory.paginate :page => params[:p], :per_page =>20,
                      :conditions => ["user_id = ?", current_user.id],
                      :order => "created_at DESC"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @memories }
    end
  end

  # GET /memories/1
  # GET /memories/1.xml
  def show
    @memory = Memory.find(params[:id])

    # MemoryForm作成
    # 3つのテキストボックス作成のために配列を用意しておく
    @memory_textboxes = (1..3).map do
      Memory.new
    end
    # Suggest用インデックス
    @memories_index = Memory.my_memory_index(current_user.id)

    # リンク構造を取得
    @incoming_edges = @memory.incoming_edges
    @outgoing_edges = @memory.outgoing_edges

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @memory }
    end
  end

  # GET /memories/1/edit
  def edit
    @memory = Memory.find(params[:id])
  end

  # POST /memories
  # POST /memories.xml
  def create
    # 登録したコンテンツにユーザー情報を付与
    for user in params[:memorytext]
      user[1].update(:user_id => current_user.id)
    end

    # まだ未登録のMemoryだった場合、登録する
    @memory_1 = Memory.is_my_memory?(params[:memorytext]['0'], current_user.id)
    @memory_2 = Memory.is_my_memory?(params[:memorytext]['1'], current_user.id)
    @memory_3 = Memory.is_my_memory?(params[:memorytext]['2'], current_user.id)

    # Memoryが3つ入力されていれば,リンク構造を6つ保存(双方向)
    if (!params[:memorytext]['0']['content'].blank? && !params[:memorytext]['1']['content'].blank? && !params[:memorytext]['2']['content'].blank?)
      @edge_1to2 = Memory.is_my_edge?(@memory_1, @memory_2, current_user.id)
      @edge_1to3 = Memory.is_my_edge?(@memory_1, @memory_3, current_user.id)
      @edge_2to1 = Memory.is_my_edge?(@memory_2, @memory_1, current_user.id)
      @edge_2to3 = Memory.is_my_edge?(@memory_2, @memory_3, current_user.id)
      @edge_3to1 = Memory.is_my_edge?(@memory_3, @memory_1, current_user.id)
      @edge_3to2 = Memory.is_my_edge?(@memory_3, @memory_2, current_user.id)
      redirect_to root_path

    # Memoryが2つ入力されていれば,リンク構造を2つ保存
    elsif (!params[:memorytext]['0']['content'].blank? && !params[:memorytext]['1']['content'].blank?)
      @edge_1to2 = Memory.is_my_edge?(@memory_1, @memory_2, current_user.id)
      @edge_2to1 = Memory.is_my_edge?(@memory_2, @memory_1, current_user.id)
      redirect_to :back

    #TODO:各リンクに重み付けを行う

    #TODO:どういう状態の時に、相手側へのフィードバックを発生させるか？
    # 【連想記憶の強化条件】
    #　　　ページを開いたとき:
    #　　　利用回数(検索回数):
    #リンクノードが増えたとき:
    #　　データを削除したとき:
    #　　データを変更したとき:
    #　　　　　頻度が高いとき:
    #パスを通ったら、(キーワードをクリックしたら)リンクを強化:
    # 【連想記憶の弱化条件】
    #ほとんど利用されてない時:
    #リンクノードが減ったとき:
    #　　データを削除したとき:
    #　　データを変更したとき:
    #　　　　　頻度が低いとき:

    # Memoryが1つの場合は,該当レコードを表示
    else
      redirect_to @memory_1
    end


=begin
    memory = current_user.memories.build(params[:memory])
    memory.save!
    redirect_to root_path
=end
=begin
    @memory = Memory.new(params[:memory])
    @memory.user_id = current_user.id

    respond_to do |format|
      if @memory.save
        flash[:notice] = 'Memory was successfully created.'
        format.html { redirect_to(:back) }
        format.xml  { render :xml => @memory, :status => :created, :location => @memory }
      else
        format.html { redirect_to(:action => "index") }
        #format.html { render :action => "new" }
        format.xml  { render :xml => @memory.errors, :status => :unprocessable_entity }
      end
    end
=end
  end

  # PUT /memories/1
  # PUT /memories/1.xml
  def update
    @memory = Memory.find(params[:id])

    respond_to do |format|
      if @memory.update_attributes(params[:memory])
        flash[:notice] = 'Memory was successfully updated.'
        format.html { redirect_to(@memory) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @memory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /memories/1
  # DELETE /memories/1.xml
  def destroy
    @memory = Memory.find(params[:id])
    @memory.destroy

    respond_to do |format|
      format.html { redirect_to(memories_url) }
      format.xml  { head :ok }
    end
  end
end
