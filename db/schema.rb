# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180306163029) do

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.string   "user_type"
    t.string   "document_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_type"
  end

  add_index "bookmarks", ["document_type", "document_id"], name: "index_bookmarks_on_document_type_and_document_id"
  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id"

  create_table "checksum_audit_logs", force: :cascade do |t|
    t.string   "file_set_id"
    t.string   "file_id"
    t.string   "version"
    t.integer  "pass"
    t.string   "expected_result"
    t.string   "actual_result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checksum_audit_logs", ["file_set_id", "file_id"], name: "by_generic_file_id_and_file_id"

  create_table "curation_concerns_operations", force: :cascade do |t|
    t.string   "status"
    t.string   "operation_type"
    t.string   "job_class"
    t.string   "job_id"
    t.string   "type"
    t.text     "message"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "lft",                        null: false
    t.integer  "rgt",                        null: false
    t.integer  "depth",          default: 0, null: false
    t.integer  "children_count", default: 0, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "curation_concerns_operations", ["lft"], name: "index_curation_concerns_operations_on_lft"
  add_index "curation_concerns_operations", ["parent_id"], name: "index_curation_concerns_operations_on_parent_id"
  add_index "curation_concerns_operations", ["rgt"], name: "index_curation_concerns_operations_on_rgt"
  add_index "curation_concerns_operations", ["user_id"], name: "index_curation_concerns_operations_on_user_id"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "qa_local_authorities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "qa_local_authorities", ["name"], name: "index_qa_local_authorities_on_name", unique: true

  create_table "qa_local_authority_entries", force: :cascade do |t|
    t.integer  "local_authority_id"
    t.string   "label"
    t.string   "uri"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "qa_local_authority_entries", ["local_authority_id"], name: "index_qa_local_authority_entries_on_local_authority_id"
  add_index "qa_local_authority_entries", ["uri"], name: "index_qa_local_authority_entries_on_uri"

  create_table "searches", force: :cascade do |t|
    t.text     "query_params"
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id"

  create_table "single_use_links", force: :cascade do |t|
    t.string   "downloadKey"
    t.string   "path"
    t.string   "itemId"
    t.datetime "expires"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "spotlight_attachments", force: :cascade do |t|
    t.string   "name"
    t.string   "file"
    t.string   "uid"
    t.integer  "exhibit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spotlight_blacklight_configurations", force: :cascade do |t|
    t.integer  "exhibit_id"
    t.text     "facet_fields"
    t.text     "index_fields"
    t.text     "search_fields"
    t.text     "sort_fields"
    t.text     "default_solr_params"
    t.text     "show"
    t.text     "index"
    t.integer  "default_per_page"
    t.text     "per_page"
    t.text     "document_index_view_types"
    t.string   "thumbnail_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spotlight_contact_emails", force: :cascade do |t|
    t.integer  "exhibit_id"
    t.string   "email",                default: "", null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spotlight_contact_emails", ["confirmation_token"], name: "index_spotlight_contact_emails_on_confirmation_token", unique: true
  add_index "spotlight_contact_emails", ["email", "exhibit_id"], name: "index_spotlight_contact_emails_on_email_and_exhibit_id", unique: true

  create_table "spotlight_contacts", force: :cascade do |t|
    t.string   "slug"
    t.string   "name"
    t.string   "email"
    t.string   "title"
    t.string   "location"
    t.string   "telephone"
    t.boolean  "show_in_sidebar"
    t.integer  "weight",          default: 50
    t.integer  "exhibit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "contact_info"
    t.string   "avatar"
    t.integer  "avatar_crop_x"
    t.integer  "avatar_crop_y"
    t.integer  "avatar_crop_w"
    t.integer  "avatar_crop_h"
  end

  add_index "spotlight_contacts", ["exhibit_id"], name: "index_spotlight_contacts_on_exhibit_id"

  create_table "spotlight_custom_fields", force: :cascade do |t|
    t.integer  "exhibit_id"
    t.string   "slug"
    t.string   "field"
    t.text     "configuration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "field_type"
  end

  create_table "spotlight_exhibits", force: :cascade do |t|
    t.string   "title",                            null: false
    t.string   "subtitle"
    t.string   "slug"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "layout"
    t.boolean  "published",        default: false
    t.datetime "published_at"
    t.string   "featured_image"
    t.integer  "masthead_id"
    t.integer  "thumbnail_id"
    t.integer  "weight",           default: 50
    t.integer  "site_id"
    t.string   "exhibitable_id"
    t.string   "exhibitable_type"
  end

  add_index "spotlight_exhibits", ["site_id"], name: "index_spotlight_exhibits_on_site_id"
  add_index "spotlight_exhibits", ["slug"], name: "index_spotlight_exhibits_on_slug", unique: true

  create_table "spotlight_featured_images", force: :cascade do |t|
    t.string   "type"
    t.boolean  "display"
    t.string   "image"
    t.string   "source"
    t.string   "document_global_id"
    t.integer  "image_crop_x"
    t.integer  "image_crop_y"
    t.integer  "image_crop_w"
    t.integer  "image_crop_h"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spotlight_filters", force: :cascade do |t|
    t.string   "field"
    t.string   "value"
    t.integer  "exhibit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "spotlight_filters", ["exhibit_id"], name: "index_spotlight_filters_on_exhibit_id"

  create_table "spotlight_locks", force: :cascade do |t|
    t.integer  "on_id"
    t.string   "on_type"
    t.integer  "by_id"
    t.string   "by_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spotlight_locks", ["on_id", "on_type"], name: "index_spotlight_locks_on_on_id_and_on_type", unique: true

  create_table "spotlight_main_navigations", force: :cascade do |t|
    t.string   "label"
    t.integer  "weight",     default: 20
    t.string   "nav_type"
    t.integer  "exhibit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "display",    default: true
  end

  add_index "spotlight_main_navigations", ["exhibit_id"], name: "index_spotlight_main_navigations_on_exhibit_id"

  create_table "spotlight_pages", force: :cascade do |t|
    t.string   "title"
    t.string   "type"
    t.string   "slug"
    t.string   "scope"
    t.text     "content"
    t.integer  "weight",            default: 50
    t.boolean  "published"
    t.integer  "exhibit_id"
    t.integer  "created_by_id"
    t.integer  "last_edited_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_page_id"
    t.boolean  "display_sidebar"
    t.boolean  "display_title"
    t.integer  "thumbnail_id"
  end

  add_index "spotlight_pages", ["exhibit_id"], name: "index_spotlight_pages_on_exhibit_id"
  add_index "spotlight_pages", ["parent_page_id"], name: "index_spotlight_pages_on_parent_page_id"
  add_index "spotlight_pages", ["slug", "scope"], name: "index_spotlight_pages_on_slug_and_scope", unique: true

  create_table "spotlight_resources", force: :cascade do |t|
    t.integer  "exhibit_id"
    t.string   "type"
    t.string   "url"
    t.text     "data"
    t.datetime "indexed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "metadata"
    t.integer  "index_status"
  end

  add_index "spotlight_resources", ["index_status"], name: "index_spotlight_resources_on_index_status"

  create_table "spotlight_roles", force: :cascade do |t|
    t.integer "user_id"
    t.string  "role"
    t.integer "resource_id"
    t.string  "resource_type"
  end

  add_index "spotlight_roles", ["resource_type", "resource_id", "user_id"], name: "index_spotlight_roles_on_resource_and_user_id", unique: true

  create_table "spotlight_searches", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "scope"
    t.text     "short_description"
    t.text     "long_description"
    t.text     "query_params"
    t.integer  "weight"
    t.boolean  "published"
    t.integer  "exhibit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "featured_item_id"
    t.integer  "masthead_id"
    t.integer  "thumbnail_id"
  end

  add_index "spotlight_searches", ["exhibit_id"], name: "index_spotlight_searches_on_exhibit_id"
  add_index "spotlight_searches", ["slug", "scope"], name: "index_spotlight_searches_on_slug_and_scope", unique: true

  create_table "spotlight_sites", force: :cascade do |t|
    t.string  "title"
    t.string  "subtitle"
    t.integer "masthead_id"
  end

  create_table "spotlight_solr_document_sidecars", force: :cascade do |t|
    t.integer  "exhibit_id"
    t.boolean  "public",        default: true
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_id"
    t.string   "document_type"
  end

  add_index "spotlight_solr_document_sidecars", ["exhibit_id"], name: "index_spotlight_solr_document_sidecars_on_exhibit_id"

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "username",               default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "guest",                  default: false
    t.text     "group_list"
    t.datetime "groups_list_expires_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "version_committers", force: :cascade do |t|
    t.string   "obj_id"
    t.string   "datastream_id"
    t.string   "version_id"
    t.string   "committer_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",                     null: false
    t.integer  "item_id",                       null: false
    t.string   "event",                         null: false
    t.string   "whodunnit"
    t.text     "object",     limit: 1073741823
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
