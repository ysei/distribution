require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

include ExampleWithGSL

describe Distribution::T do
shared_examples_for "T engine(with rng)" do
  it "should return correct rng" do
  pending()
  end
end

shared_examples_for "T engine(with pdf)" do
  it_only_with_gsl "should return correct pdf" do
    if @engine.respond_to? :pdf
      [-2,0.1,0.5,1,2].each{|t|
        [2,5,10].each{|n|
          @engine.pdf(t,n).should be_within(1e-6).of(GSL::Ran.tdist_pdf(t,n))

        }
      }
    else
      pending("No #{@engine}.pdf")
    end
  end
end

shared_examples_for "T engine" do
  
  it_only_with_gsl "should return correct cdf" do
    if @engine.respond_to? :cdf
      [-2,0.1,0.5,1,2].each{|t|
        [2,5,10].each{|n|
          @engine.cdf(t,n).should be_within(1e-4).of(GSL::Cdf.tdist_P(t,n))
        }
      }
    else
      pending("No #{@engine}.cdf")
    end
  
  end
  it "should return correct p_value" do
    if @engine.respond_to? :p_value
   [-2,0.1,0.5,1,2].each{|t|
        [2,5,10].each{|n|
          area=Distribution::T.cdf(t,n)
          @engine.p_value(area,n).should be_within(1e-4).of(GSL::Cdf.tdist_Pinv(area,n))
    }
    }
    else
      pending("No #{@engine}.p_value")
    end
  end
end

  describe "singleton" do
    before do
      @engine=Distribution::T
    end
    it_should_behave_like "T engine"    
    it_should_behave_like "T engine(with pdf)"    
  end
  
  describe Distribution::T::Ruby_ do
    before do
      @engine=Distribution::T::Ruby_
    end
    it_should_behave_like "T engine"    
    it_should_behave_like "T engine(with pdf)"    
  end
  if Distribution.has_gsl?
    describe Distribution::T::GSL_ do
      before do
        @engine=Distribution::T::GSL_
      end
    it_should_behave_like "T engine"    
    it_should_behave_like "T engine(with pdf)"    
    end
  end  
  if Distribution.has_statistics2?
    describe Distribution::T::Statistics2_ do
      before do
        @engine=Distribution::T::Statistics2_
      end
    it_should_behave_like "T engine"    
    end  
  end
  
  if Distribution.has_java?
    describe Distribution::T::Java_ do
      before do
        @engine=Distribution::T::Java_
      end
    it_should_behave_like "T engine"    
    it_should_behave_like "T engine(with pdf)"    
    end  
  end
  
end
