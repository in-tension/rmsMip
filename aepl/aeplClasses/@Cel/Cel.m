classdef Cel < Handle
    %CELL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id
        xcoords
        ycoords
        coords
        area
        covarience
        distance
        
    end
    
    methods
        function obj = Cel(id)
            %CELL Construct an instance of this class
            %   Detailed explanation goes here
            obj.id = id;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.name + inputArg;
        end
    end
end

