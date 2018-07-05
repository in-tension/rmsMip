classdef DatCon < handle
    
    properties
        name                % chars
        id                  % int[]
        parent              % DatCon or 'root'
        
        children            % DatCon[]
        childCount          % int
        childIndexMap       % Map<chars,int>
        
        top                 % DatCon
        level               % int
        depth               % depth
        
        
    end
    
    
    
    methods
        
        function obj = DatCon(name,parent)
            obj.name = name;
            if ischar(parent) || isstring(parent) && strcmp(parent,'top')
                % special case constructor for root
                
                obj.id = [1];
                obj.parent = parent;
                
                obj.children = DatCon.empty(0);
                obj.childCount = 0;
                obj.childIndexMap = containers.Map();
                
                obj.top = obj;
                obj.level = 1;
                obj.depth = 1;
                
            else
                % normal constructor
                if ~isa(parent, 'DatCon')
                    error("parent must be a DatCon or 'top' ")
                else
                    obj.parent = parent;
                    obj.level = obj.parent.level + 1;

                    obj.depth = obj.level;

                    
                    obj.top = obj.parent.top;
                 
                    obj.children = DatCon.empty(0);
                    obj.childCount = 0;
                    obj.childIndexMap = containers.Map();
                        
                    
                    obj.parent.updateChildren(obj)
                    
                    obj.id = [obj.parent.id obj.parent.childCount];

                  
                end
            end
        end
        
        
        function updateChildren(obj,child)
            obj.childCount = obj.childCount + 1;
            obj.children(obj.childCount) = child;
            obj.childIndexMap(child.name) = obj.childCount;
            
            p = child.parent;          
            while ~strcmp('top',p)
                if child.depth > p.depth
                    p.depth = child.depth;
                end
                p = p.parent;
            end
           
        end
        
        
        function addChild(obj,name)
           temp = DatCon(name,obj)
            
        end
        
        function child = grab(obj,varargin)
            if length(varargin) > obj.depth - obj.level
                disp('too many indices?')
            else
               if isnumeric(varargin{1})
                  index = varargin{1};
               elseif ischar(varargin{1}) || isstring(varargin{1})
                  index = obj.childIndexMap(varargin{1});
               end
               
               if length(varargin) == 1
                   child = obj.children(index);
               else
                   child = obj.children(index).grab(varargin{2:end});
               end
                   
            end
        end
        
        function str = toString(obj)
            spcs = (obj.level-1);
            str = "";
            for i = 1:spcs-1
                str = str + "| ";
            end
            if spcs >= 1
            str = str + "\x221F-"; 
            end
            
            str = strcat(str,obj.name,'\n');
            for c = 1:obj.childCount
                str = str + obj.children(c).toString();
            end
            
        end
        
        function floop(obj,func)
            func(obj)
           for c = 1:obj.childCount
               % floop ...
              obj.children(c).floop(func)
           end
        end
        
        
        function bool = isAnc(obj,cont)
            
            
        end
        
        
        function conRef = getRef(obj,cont
        
        
        
        function test(obj)
            disp(['[',num2str(obj.id),'] - ',obj.name])
        end
        
        
        
%         function colStr = toString2(obj,curId,red)
%             spcs = (obj.level-1);
%             str = "";
%             for i = 1:spcs-1
%                 str = str + "| ";
%             end
%             if ~red
%                 
%             
%             
%             if spcs >= 1
%             str = str + "\x221F-"; 
%             end
%             
%             str = strcat(str,obj.name,'\n');
%             for c = 1:obj.childCount
%                 %if o
%                 str = str + obj.children(c).toString();
%             end
%             
%         end

        function [fore,cur,aft] = toStringParts(obj,curId)
            
            fore = "";
            cur = "";
            aft = "";
            
            spcs = (obj.level-1);
            str = "";
            for i = 1:spcs-1
                str = str + "| ";
            end
            if spcs >= 1
            str = str + "\x221F-"; 
            end
            str = strcat(str,obj.name,'\n');
            for c = 1:obj.childCount
                disp(str)
                length(obj.children(c).id) == length(curId)
                if (length(obj.children(c).id) == length(curId)) && all(obj.children(c).id == curId)
                   fore = str;
                   cur = obj.children(c).toString();
                   str = "";
                   
                else
                    %disp(
                    str = str + obj.children(c).toString();
                end
            end
            aft = str;
            
        end
        
        
        function disp(obj)
            if length(obj) == 1
                %disp(obj.name)
                %obj.dispCur()
                builtin('disp',obj)
            else
               for o = obj
                   disp(o.name)
               end
            end
        end
        
        
        function dispCur(obj) 
           [fore,cur,aft] = obj.top.toStringParts(obj.id);
           cprintf('blue',fore)
           cprintf('red',cur)
           cprintf('green',aft)
        end
        
        
    end
end
    
    
