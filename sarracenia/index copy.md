---
layout: page
title: Expeditions
description: Blog of an ecologist exploring the world.
background: '/sarracenia/assets/images/bg-expeditions.jpg'
---

Sarracenia is a genus comprising 8 to 11 species of North American pitcher plants, commonly called trumpet pitchers. The genus belongs to the family Sarraceniaceae, which also contain the closely allied genera Darlingtonia and Heliamphora.

Sarracenia is a genus of carnivorous plants indigenous to the eastern seaboard of the United States, Texas, the Great Lakes area and southeastern Canada, with most species occurring only in the south-east United States (only S. purpurea occurs in cold-temperate regions). The plant's leaves have evolved into a funnel or pitcher shape in order to trap insects.
  
The plant attracts its insect prey with secretions from extrafloral nectaries on the lip of the pitcher leaves, as well as a combination of the leaves' color and scent. Slippery footing at the pitcher's rim, causes insects to fall inside, where they die and are digested by the plant with proteases and other enzymes.


<div style="display:flex">
  <div style="flex:1; padding-right:10px;">
  <a href="{{"/sarracenia/species/Sarracenia_alata" | relative_url }}">
     <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Sarracenia_alata_flowers.jpg/1200px-Sarracenia_alata_flowers.jpg"/>
     <figcaption>Sarracenia alata</figcaption></a>
  </div>
  <div style="flex:1;padding-right:10px;">
     <a href="{{"/sarracenia/species/Sarracenia_alata" | relative_url }}">
     <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/>
     <figcaption>Sarracenia alata</figcaption></a>
  </div>
  <div style="flex:1;padding-right:10px;">
       <a href="{{"/sarracenia/species/Sarracenia_alata" | relative_url }}">
       <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/>
       <figcaption>Sarracenia alata</figcaption></a>
  </div>
  <div style="flex:1;padding-right:10px;">
    <a href="{{"/sarracenia/species/Sarracenia_alata" | relative_url }}">
    <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/>
    <figcaption>Sarracenia alata</figcaption></a>
</div>
</div>

Here below are all varieties of Sarracenia offered, so that you can browse them visually. Enjoy the hummongous diversity of forms and colors... ohh my goodness!!


<div class="row"> 
  <div class="column">
    <a href="{{"/sarracenia/species/Sarracenia_alata" | relative_url }}">
        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Sarracenia_alata_flowers.jpg/1200px-Sarracenia_alata_flowers.jpg"/></a>
    <a href="{{"/sarracenia/species/Sarracenia_flava" | relative_url }}">
        <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/></a>
    <a href="{{"/sarracenia/species/Sarracenia_leucophylla" | relative_url }}">
        <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/></a>
    <a href="{{"/sarracenia/species/Sarracenia_minor" | relative_url }}">
        <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/></a>
  </div>
  <div class="column">
    <a href="{{"/sarracenia/species/Sarracenia_oreophila" | relative_url }}">
        <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/></a>
    <a href="{{"/sarracenia/species/Sarracenia_psittacina" | relative_url }}">
        <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/></a>
    <a href="{{"/sarracenia/species/Sarracenia_purpurea" | relative_url }}">
        <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/></a>
    <a href="{{"/sarracenia/species/Sarracenia_rosea" | relative_url }}">
        <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/></a>
  </div> 
    <div class="column">
    <a href="{{"/sarracenia/species/Sarracenia_rubra" | relative_url }}">
        <img src="https://upload.wikimedia.org/wikipedia/commons/a/aa/Sarracenia_leucophylla_at_the_Brooklyn_Botanic_Garden_%2881396%29b.jpg"/></a>
    <a href="{{"/sarracenia/species/Hybrids" | relative_url }}">
        <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/></a>
    <a href="{{"/sarracenia/species/Sarracenia_alata" | relative_url }}">
        <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/></a>
    <a href="{{"/sarracenia/species/Sarracenia_alata" | relative_url }}">
        <img src="http://www.sarracenia.com/photos/sarracenia/sarraalata013.jpg"/></a>
  </div> 
</div>

{% for post in site.posts %}
{%- if post.category == "sarracenia" -%}

<article class="post-preview">
  <a href="{{ post.url | prepend: site.baseurl | replace: '//', '/' }}">
    <img src="{{ post.background | prepend: site.baseurl | replace: '//', '/' }}" alt="" class="blog-roll-image">
    <h2 class="post-title">{{ post.title }}</h2>
    {% if post.subtitle %}
    <h3 class="post-subtitle">{{ post.subtitle }}</h3>
    {% else %}
    <h3 class="post-subtitle">{{ post.excerpt | strip_html | truncatewords: 15 }}</h3>
    {% endif %}
  </a>
  <p class="post-meta">{{ post.date | date: '%B %d, %Y' }} &middot; {% include read_time.html content=post.content %}
  </p>
</article>

<hr>

{%- endif -%}
{% endfor %}

<!-- Pager -->
{% if paginator.total_pages > 1 %}

<div class="clearfix">

  {% if paginator.previous_page %}
  <a class="btn btn-primary float-left" href="{{ paginator.previous_page_path | prepend: site.baseurl | replace: '//', '/' }}">&larr;
    Newer<span class="d-none d-md-inline"> Posts</span></a>
  {% endif %}

  {% if paginator.next_page %}
  <a class="btn btn-primary float-right" href="{{ paginator.next_page_path | prepend: site.baseurl | replace: '//', '/' }}">Older<span class="d-none d-md-inline"> Posts</span> &rarr;</a>
  {% endif %}

</div>

{% endif %}
