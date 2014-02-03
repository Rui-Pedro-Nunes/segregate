require 'spec_helper'

describe Segregate do
  it 'should be an instance of Class' do
    expect(Segregate).to be_an_instance_of Class
  end

  describe '::new' do
  	it 'returns an instance of Segregate' do
  		expect(Segregate.new).to be_an_instance_of Segregate
  	end

    it 'has the inital values' do
      @parser = Segregate.new
      expect(@parser.request?).to be_false
      expect(@parser.response?).to be_false
      expect(@parser.uri).to be_nil
      expect(@parser.request_line).to be_nil
      expect(@parser.request_method).to be_nil
      expect(@parser.request_url).to be_nil
      expect(@parser.status_line).to be_nil
      expect(@parser.status_code).to be_nil
      expect(@parser.status_phrase).to be_nil
      expect(@parser.http_version).to eq [nil, nil]
      expect(@parser.major_http_version).to be_nil
      expect(@parser.minor_http_version).to be_nil
      expect(@parser.headers).to be_empty
      expect(@parser.body).to be_empty
    end
  end

  context 'a new parser has been created' do
    before(:each) do
      @parser = Segregate.new
    end

    describe '#parse' do
      it 'accepts one argument' do
        expect(@parser).to respond_to(:parse).with(1).argument
      end

      it 'errors if an incorrect first line is received' do
        expect{@parser.parse "fail\r\n"}.to raise_error RuntimeError, 'ERROR: Unknown first line: fail'
      end

      it 'errors if an incorrect http method is received' do
        expect{@parser.parse "FAIL /endpoint HTTP/1.1\r\n"}.to raise_error RuntimeError, 'ERROR: Unknown http method: FAIL'
      end
    end

    context 'a request line has been parsed' do
      before(:each) do
        @parser.parse "GET /endpoint HTTP/1.1\r\n"
      end

      describe '#request_line' do
        it 'returns a string' do
          expect(@parser.request_line).to be_an_instance_of String
        end

        it 'returns a request line' do
          expect(@parser.request_line).to match Segregate::REQUEST_LINE
        end
      end

      describe '#status_line' do
        it 'returns nil' do
          expect(@parser.status_line).to be_nil
        end
      end

      describe '#request?' do
        it 'returns true' do
          expect(@parser.request?).to be_an_instance_of TrueClass
        end
      end

      describe '#response?' do
        it 'returns false' do
          expect(@parser.response?).to be_an_instance_of FalseClass
        end
      end

      describe '#http_version' do
        it 'returns an array' do
          expect(@parser.http_version).to be_an_instance_of Array
        end

        it 'returns [1, 1]' do
          expect(@parser.http_version).to eql [1,1]
        end
      end

      describe '#major_http_version' do
        it 'returns an integer' do
          expect(@parser.major_http_version).to be_an_instance_of Fixnum
        end

        it 'returns 1' do
          expect(@parser.major_http_version).to eql 1
        end
      end

      describe '#minor_http_version' do
        it 'returns an integer' do
          expect(@parser.minor_http_version).to be_an_instance_of Fixnum
        end

        it 'returns 1' do
          expect(@parser.minor_http_version).to eql 1
        end
      end

      describe '#request_method' do
        it 'returns an string' do
          expect(@parser.request_method).to be_an_instance_of String
        end

        it 'returns GET' do
          expect(@parser.request_method).to eq 'GET'
        end
      end

      describe '#request_url' do
        it 'returns an string' do
          expect(@parser.request_url).to be_an_instance_of String
        end

        it 'returns /endpoint' do
          expect(@parser.request_url).to eq '/endpoint'
        end
      end

      describe '#status_code' do
        it 'returns nil' do
          expect(@parser.status_code).to be_nil
        end
      end

      describe '#status_phrase' do
        it 'returns nil' do
          expect(@parser.status_phrase).to be_nil
        end
      end

      describe '#uri' do
        it 'returns a URI' do
          expect(@parser.uri).to be_an_instance_of URI::Generic
        end
      end

      describe '#path' do
        it 'returns the uri path' do
          expect(@parser.path).to eq '/endpoint'
        end
      end
    end

    context 'a response line has been parsed' do
      before(:each) do
        @parser.parse "HTTP/1.1 200 OK\r\n"
      end

      describe '#request_line' do
        it 'returns nil' do
          expect(@parser.request_line).to be_nil
        end
      end

      describe '#status_line' do
        it 'returns a string' do
          expect(@parser.status_line).to be_an_instance_of String
        end

        it 'returns a status line' do
          expect(@parser.status_line).to match Segregate::STATUS_LINE
        end
      end

      describe '#request?' do
        it 'returns false' do
          expect(@parser.request?).to be_an_instance_of FalseClass
        end
      end

      describe '#response?' do
        it 'returns true' do
          expect(@parser.response?).to be_an_instance_of TrueClass
        end
      end

      describe '#http_version' do
        it 'returns an array' do
          expect(@parser.http_version).to be_an_instance_of Array
        end

        it 'returns [1, 1]' do
          expect(@parser.http_version).to eql [1,1]
        end
      end

      describe '#major_http_version' do
        it 'returns an integer' do
          expect(@parser.major_http_version).to be_an_instance_of Fixnum
        end

        it 'returns 1' do
          expect(@parser.major_http_version).to eql 1
        end
      end

      describe '#minor_http_version' do
        it 'returns an integer' do
          expect(@parser.minor_http_version).to be_an_instance_of Fixnum
        end

        it 'returns 1' do
          expect(@parser.minor_http_version).to eql 1
        end
      end

      describe '#request_method' do
        it 'returns nil' do
          expect(@parser.request_method).to be_nil
        end
      end

      describe '#request_url' do
        it 'returns nil' do
          expect(@parser.request_url).to be_nil
        end
      end

      describe '#status_code' do
        it 'returns an integer' do
          expect(@parser.status_code).to be_an_instance_of Fixnum
        end

        it 'returns 200' do
          expect(@parser.status_code).to eql 200
        end
      end

      describe '#status_phrase' do
        it 'returns an string' do
          expect(@parser.status_phrase).to be_an_instance_of String
        end

        it 'returns OK' do
          expect(@parser.status_phrase).to eq 'OK'
        end
      end

      describe '#uri' do
        it 'returns nil' do
          expect(@parser.uri).to be_nil
        end
      end
    end

    context 'a header has been parsed' do
      before(:each) do
        @parser.parse "GET /endpoint HTTP/1.1\r\n"
        @parser.parse "Accept: application/json\r\n"
      end

      describe '#headers' do
        it 'returns an instans of a hashie mash' do
          expect(@parser.headers).to be_an_instance_of Hashie::Mash
        end

        it 'contains the parsed header' do
          expect(@parser.headers).to respond_to(:accept)
          expect(@parser.headers.accept).to eq 'application/json'
        end
      end

      describe '#headers_complete?' do
        it 'returns false' do
          expect(@parser.headers_complete?).to be_an_instance_of FalseClass
        end
      end
    end

    context 'all headers have been parsed' do
      before(:each) do
        @parser.parse "GET /endpoint HTTP/1.1\r\n"
        @parser.parse "Accept: application/json\r\n"
        @parser.parse "Host: www.google.com\r\n"
        @parser.parse "\r\n"
      end

      describe '#headers' do
        it 'returns an instans of a hashie mash' do
          expect(@parser.headers).to be_an_instance_of Hashie::Mash
        end

        it 'contains all the parsed headers' do
          expect(@parser.headers).to respond_to(:accept)
          expect(@parser.headers).to respond_to(:host)
          expect(@parser.headers.accept).to eq 'application/json'
          expect(@parser.headers.host).to eq 'www.google.com'
        end
      end

      describe '#headers_complete?' do
        it 'returns true' do
          expect(@parser.headers_complete?).to be_an_instance_of TrueClass
        end
      end
    end

    context 'a body has been parsed' do
      before(:each) do
        @parser.parse "GET /endpoint HTTP/1.1\r\n"
        @parser.parse "Host: www.google.com\r\n"
        @parser.parse "Content-Length: 20\r\n"
        @parser.parse "\r\n"
        @parser.parse "This is the content!\r\n\r\n"
      end

      describe '#body' do
        it 'returns a string' do
          expect(@parser.body).to be_an_instance_of String
        end

        it 'contains the body text' do
          expect(@parser.body).to eq "This is the content!"
        end
      end

      describe '#body_complete?' do
        it 'returns true' do
          expect(@parser.body_complete?).to be_an_instance_of TrueClass
        end
      end
    end

    context 'a partial chunked body has been parsed' do
      before(:each) do
        @parser.parse "GET /endpoint HTTP/1.1\r\n"
        @parser.parse "Host: www.google.com\r\n"
        @parser.parse "Content-Encoding: chunked\r\n"
        @parser.parse "\r\n"
        @parser.parse "26\r\nThis is the first content!\r\n"
      end

      describe '#body' do
        it 'returns a string' do
          expect(@parser.body).to be_an_instance_of String
        end

        it 'contains the body text' do
          expect(@parser.body).to eq "This is the first content!"
        end
      end

      describe '#body_complete?' do
        it 'returns false' do
          expect(@parser.body_complete?).to be_an_instance_of FalseClass
        end
      end

      context 'the body parsing is completed' do
        before(:each) do
          @parser.parse "27\r\nThis is the second content!\r\n"
          @parser.parse "0\r\n\r\n"
        end

        describe '#body' do
          it 'returns a string' do
            expect(@parser.body).to be_an_instance_of String
          end

          it 'contains the body text' do
            expect(@parser.body).to eq "This is the first content!This is the second content!"
          end
        end

        describe '#body_complete?' do
          it 'returns true' do
            expect(@parser.body_complete?).to be_an_instance_of TrueClass
          end
        end
      end
    end
  end
end