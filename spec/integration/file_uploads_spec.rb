# frozen_string_literal: true

require_relative '../spec_helper'
require 'tempfile'

def create_test_pdf
  # noinspection RubyMismatchedArgumentType
  tempfile = Tempfile.new(%w[test .pdf])
  tempfile.write <<~FILE
    Test data
  FILE
  tempfile.close
  tempfile.open
  tempfile
end

describe Shift4::FileUploads do
  each_context(*standard_contexts) do
    it 'test upload by file' do
      # given
      tempfile = create_test_pdf
      # when
      uploaded = Shift4::FileUploads.upload(tempfile, { purpose: 'dispute_evidence' })
      # then
      expect(uploaded['id']).not_to be_nil
    end

    it 'test get' do
      # given
      uploaded = Shift4::FileUploads.upload(create_test_pdf, { purpose: 'dispute_evidence' })
      # when
      retrieved = Shift4::FileUploads.retrieve(uploaded['id'])
      # then
      expect(retrieved['id']).to eq(uploaded['id'])
    end

    it 'test list' do
      # given
      uploaded = Shift4::FileUploads.upload(create_test_pdf, { purpose: 'dispute_evidence' })
      # when
      listed = Shift4::FileUploads.list({ limit: 100 })
      # then
      expect(listed['list'].map { |it| it['id'] })
        .to include(uploaded['id'])
    end
  end
end
