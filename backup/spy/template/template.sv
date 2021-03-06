class {{sv_class.get_sv_type()}};
    {%- for var in sv_class.var_dict.values() %}
    {%- for content in var.render_declare() %}
    {{content}}
    {%- endfor %}
    {%- endfor %}

    function new();
    {%- for content in sv_class.render_instantiate() %}
        {{content}}
    {%- endfor %}
    endfunction: new

    function load_value(string path, string hierarchy = "{{sv_class.get_sv_type()}}");
        int     f, fp;
        string  content, line, attr_name, value;
        string  tmp;
        int     len;

        f = $fopen(path, "r");
        do begin
            content = "";
            fp = $fgets(line, f);
            for (int i=0; i<line.len(); i++) begin
                if (line.getc(i) == "#") begin
                    break;
                end else if ((line.getc(i) != " ") && (line.getc(i) != "\t") && (line.getc(i) != "\n")) begin
                    content = {content, line.getc(i)};
                end
            end

            {%- for content in sv_class.render_scan_value() %}
            {{content}}
            {%- endfor %}
        end while (fp);
        $fclose(f);
        {%- for content in sv_class.render_load_value() %}
        {{content}}
        {%- endfor %}
    endfunction: load_value
    
    function print_value(string hierarchy = "{{sv_class.get_sv_type()}}");
        {%- for content in sv_class.render_print_value() %}
        {{content}}
        {%- endfor %}
    endfunction: print_value
    
    function output_value(string path, string hierarchy = "{{sv_class.get_sv_type()}}", int f=0);
        bit f_root;

        if (f == 0) begin
            f = $fopen(path, "w");
            f_root = 1;
        end

        {%- for content in sv_class.render_output_value() %}
        {{content}}
        {%- endfor %}

        if (f_root) $fclose(f);
    endfunction: output_value
endclass: {{sv_class.get_sv_type()}}