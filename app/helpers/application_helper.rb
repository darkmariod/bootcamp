module ApplicationHelper
  def usd(amount)
    number_to_currency(amount, unit: "$", separator: ".", delimiter: ",", precision: 2, format: "%u%n")
  end

  def nav_link(label, path, icon_name, active: false, badge: nil)
    link_to path, class: "nav-item #{'nav-item-active' if active}" do
      body = icon(icon_name) + tag.span(label)
      body += tag.span(badge, class: "ml-auto text-[10px] px-1.5 py-0.5 rounded bg-brass-400/20 text-brass-300 font-semibold") if badge
      body
    end
  end

  def case_type_badge(legal_case)
    colors = {
      "transito" => "bg-sky-100 text-sky-800",
      "penal" => "bg-red-100 text-red-800",
      "alimentos" => "bg-brass-100 text-brass-800",
      "laboral" => "bg-ink-100 text-ink-700",
      "civil" => "bg-stone-200 text-stone-700"
    }
    tag.span(legal_case.case_type_label, class: "pill #{colors[legal_case.case_type]}")
  end

  def status_badge(legal_case)
    colors = {
      "abierto" => "bg-emerald-100 text-emerald-800",
      "en_tramite" => "bg-sky-100 text-sky-800",
      "audiencia" => "bg-brass-100 text-brass-800",
      "sentencia" => "bg-ink-100 text-ink-700",
      "archivado" => "bg-stone-200 text-stone-600"
    }
    tag.span(legal_case.status_label, class: "pill #{colors[legal_case.status]}")
  end

  def proforma_status_badge(proforma)
    colors = {
      "borrador" => "bg-stone-200 text-stone-700",
      "enviada" => "bg-sky-100 text-sky-800",
      "aceptada" => "bg-emerald-100 text-emerald-800",
      "rechazada" => "bg-red-100 text-red-800"
    }
    tag.span(proforma.status_label, class: "pill #{colors[proforma.status]}")
  end

  def page_header(title, subtitle = nil, &block)
    tag.div(class: "flex items-start justify-between gap-4 mb-7") do
      left = tag.div do
        h = tag.h1(title, class: "display text-[27px] leading-tight font-semibold text-ink-900")
        s = subtitle ? tag.p(subtitle, class: "text-sm text-stone-500 mt-1.5") : "".html_safe
        h + s
      end
      right = block ? tag.div(capture(&block), class: "shrink-0") : "".html_safe
      left + right
    end
  end
end
