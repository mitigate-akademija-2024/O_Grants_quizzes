module ApplicationHelper
    def btn_class
        "inline-block rounded border border-indigo-600 bg-indigo-600 px-12 py-3 text-sm font-medium text-white hover:bg-transparent hover:text-indigo-600 focus:outline-none focus:ring active:text-indigo-500"
    end
    
    def btn_class_small
        'inline-block rounded border border-indigo-600 bg-indigo-600 px-1 py-1 text-xs font-medium text-white hover:bg-transparent hover:text-indigo-600 focus:outline-none focus:ring active:text-indigo-500'
    end

    def format_date(date)
        date.strftime('%F')
    end
end