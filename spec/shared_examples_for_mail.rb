RSpec.shared_examples 'a signable mail' do
  let!(:mail) do
    Mail.new(
      from: sender,
      to: recipient,
      subject: 'This is a test email',
      body: 'This is a test body'
    ).tap(&:inform_interceptors)
  end

  it 'contains S/MIME in the body' do
    expect(mail.body.to_s).to include 'This is an S/MIME signed message'
  end

  it 'kept the original' do
    expect(mail.body.to_s).to include 'This is a test body'
  end

  it 'retained content_disposition' do
    expect(mail.content_disposition).to be_nil
  end

  it 'retained content_transfer_encoding' do
    expect(mail.content_transfer_encoding).not_to eql 'base64'
  end

  it 'changed content_type' do
    expect(mail.content_type).to match %r{multipart/signed}
  end
end

RSpec.shared_examples 'a non signable mail' do
  let!(:mail) do
    Mail.new(
      from: sender,
      to: recipient,
      subject: 'This is a test email',
      body: 'This is a test body'
    ).tap(&:inform_interceptors)
  end

  it 'does not S/MIME in the body' do
    expect(mail.body.to_s).not_to include 'This is an S/MIME signed message'
  end

  it 'kept the original' do
    expect(mail.body.to_s).to include 'This is a test body'
  end

  it 'retained content_disposition' do
    expect(mail.content_disposition).to be_nil
  end

  it 'retained content_transfer_encoding' do
    expect(mail.content_transfer_encoding).not_to eql 'base64'
  end

  it 'retained content_type' do
    expect(mail.content_type).not_to match %r{multipart/signed}
  end
end

RSpec.shared_examples 'a encryptable mail' do
  let!(:mail) do
    Mail.new(
      from: sender,
      to: recipient,
      subject: 'This is a test email',
      body: 'This is a test body'
    ).tap(&:inform_interceptors)
  end

  it 'has an encrypted body' do
    expect(mail.body.to_s).not_to include 'This is a test body'
    expect(mail.body.to_s).not_to include 'This is an S/MIME signed message'
  end

  it 'changed content_disposition' do
    expect(mail.content_disposition).to eql 'attachment; filename=smime.p7m'
  end

  it 'changed content_transfer_encoding' do
    expect(mail.content_transfer_encoding).to eql 'base64'
  end

  it 'changed content_type' do
    expect(mail.content_type).to eql 'application/pkcs7-mime; name=smime.p7m; smime-type=enveloped-data'
  end
end

RSpec.shared_examples 'a non encryptable mail' do
  let!(:mail) do
    Mail.new(
      from: sender,
      to: recipient,
      subject: 'This is a test email',
      body: 'This is a test body'
    ).tap(&:inform_interceptors)
  end

  it 'kept the original' do
    expect(mail.body.to_s).to include 'This is a test body'
  end

  it 'retained content_disposition' do
    expect(mail.content_disposition).to be_nil
  end

  it 'retained content_transfer_encoding' do
    expect(mail.content_transfer_encoding).not_to eql 'base64'
  end

  it 'retained content_type' do
    expect(mail.content_type).not_to eql 'application/pkcs7-mime; name=smime.p7m; smime-type=enveloped-data'
  end
end
