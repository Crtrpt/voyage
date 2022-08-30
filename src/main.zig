const print  = @import("std").debug.print;
const std=@import("std");


const ChildrenNode=struct{
    len:u8=0,
    //第一个
    first:?*Node=null,
    //最后一个
    last:?*Node=null,
    //头部添加
     pub fn headAdd(self:*ChildrenNode,ele:*Node)void{
        self.len+=1;
        ele.next=self.first;
        self.first=ele;
    }
    //头部删除
   pub fn headRemove(self:*ChildrenNode)void{
        self.len-=1;
        var node=self.first;
        self.first= self.next;
        node.next=null;
    }
    //底部添加
    pub fn tailAdd(self:*ChildrenNode,ele:*Node) void {
        self.len+=1;
        if(self.len==1){
            self.first=ele;
            self.last=ele;
        }else{
            self.last.?.*.next=ele;
            ele.prev=self.last;
            self.last=ele;
        }
    }
    //底部删除
    pub fn tailRemove(self: *ChildrenNode) void {
        self.len-=1;
        var node=self.last;
        self.last= node.prev;
        node.prev=null;
    }
    pub fn render(self: *ChildrenNode)void {
        var cur=self.first;
        while(true){
            if (cur) |node| {
                node.render();
                cur=node.next;
            } else {
                break;
            }
           
        }
    }
};

const Node=struct {
    name: []const u8,
    parent:?*Node=null,
    //第一个元素
    children:ChildrenNode = ChildrenNode{},
    //下一个元素
    next:?*Node=null,
    //上一个元素
    prev:?*Node=null,

    attr:?*std.hash_map=null,
    events:?*std.hash_map=null,
    fn setParent(self:*Node,parent:*Node) void {
        self.parent=parent;
        parent.children.tailAdd(self);
    }
    fn render(self: *Node) void {
        //print("addr:{s}\n", .{self.name});
        self.emit("render_before");
        self.children.render();
        self.emit("render");
    }
    fn emit(self: *Node,name:[]const u8) void {
        print("name:{s} event:{s}\n", .{self.name,name});
    }
};

pub fn main() !void {
    var root=Node{
        .name="root"
    };

    var e= Node{
        .name="ele1",
    };
    e.setParent(&root);
    
    var e1= Node{
        .name="ele2",
    };
    e1.setParent(&root);

     var e2= Node{
        .name="ele3",
    };
    e2.setParent(&root);

    root.render();

    print("{d}\n", .{root.children.len});


    
    // print("{s}\n", .{@typeName(@TypeOf(e))}); 
}



